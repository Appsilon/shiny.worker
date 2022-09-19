#' Shiny Worker R6 Class
#' @importFrom future future
#' @importFrom shiny reactive
#' @importFrom shiny invalidateLater
#' @importFrom R6 R6Class
#' @export
Worker <- R6Class("Worker", #nolint
  public = list(
    #' @description
    #' Initialize the worker's registry
    initialize = function() {
      plan(multiprocess)
    },
    #' @description
    #' Add job to the registry
    #' @param id character with job id
    #' @param fun function to calculate
    #' @param args_reactive reactive arguments that trigger the job
    #' @param value_until_resolved default value returned until the job is completed
    #' @param invalidate_time wait time before invalidating reactive context (msec)
    #'
    #' @return reactive expression with promise of job completion
    run_job = function(id, fun, args_reactive, value_until_resolved = NULL,
                       invalidate_time = 1000) {
      reactive({

        args_prepared <- args_reactive()

        result <- value_until_resolved

        if (!private$job_is_active(id)) {
          private$job_schedule(id, fun, args_prepared)
        } else if (private$job_is_resolved(id)) {
          result <- private$job_value(id)
          private$job_reset(id)
        }

        if (!private$job_is_resolved(id)) invalidateLater(invalidate_time)

        list(result = result, resolved = private$job_is_resolved(id))
      })
    },
    #' @description
    #' Displays jobs registry.
    get_job_registry = function() {
      private$job_registry
    }
  ),
  private = list(
    job_registry = list(),
    job_schedule = function(id, fun, args) {
      private$job_registry[[id]] <- future(fun(args))
      if (isTRUE(getOption("worker.debug.mode")))
        print(paste("Job scheduled:", id))
    },
    job_is_resolved = function(id) {
      result <- resolved(private$job_registry[[id]])
      if (isTRUE(getOption("worker.debug.mode")))
        print(paste("Resolved?", result))
      result
    },
    job_is_active = function(id) {
      !is.null(private$job_registry[[id]])
    },
    job_value = function(id) {
      if (is.null(private$job_registry[[id]])) {
        NULL
      } else {
        value(private$job_registry[[id]])
      }
    },
    job_reset = function(id) {
      private$job_registry[[id]] <- NULL
    }
  )
)


#' Creates new shiny.worker object
#'
#' @return shiny.worker object
#' @export
#'
#' @examples
#' if(interactive()){
#'  worker <- initialize_worker()
#' }
initialize_worker <- function() {
  Worker$new()
}
