job_registry <- list()

job_schedule <- function(id, fun, args) {
  job_registry[[id]] <<- future(fun(args))
  print(paste("Job scheduled:", id))
}

job_is_resolved <- function(id) {
  result <- resolved(job_registry[[id]])
  print(paste("Resolved?", result))
  result
}

job_is_active <- function(id) {
  !is.null(job_registry[[id]])
}

job_value <- function(id) {
  if (is.null(job_registry[[id]])) {
    NULL
  } else {
    value(job_registry[[id]])
  }
}

job_reset <- function(id) {
  job_registry[[id]] <<- NULL
}

shinyWorker <- function(id, fun, args_reactive, value_until_resolved = NULL) {
  reactive({

    args_prepared <- args_reactive()

    result <- value_until_resolved

    if(!job_is_active(id)) {
      job_schedule(id, fun, args_prepared)
    } else if (job_is_resolved(id)) {
      result <- job_value(id)
      job_reset(id)
    }

    if (!job_is_resolved(id)) invalidateLater(1000)

    result
  })
}
