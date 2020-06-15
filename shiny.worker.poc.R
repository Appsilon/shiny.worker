library(future)
library(shiny)
library(jsonlite)
library(httr)

plan(multiprocess)

ui <- fluidPage(
  
  # Application title
  titlePanel("shiny.worker poc"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      div("Play with the slider. Histogram will be still responsive, even if job is running:"),
      br(),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      div("Then try to run new job again:"),
      br(),
      actionButton("triggerButton", "Run job (5 sec.)")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(
        column(6, plotOutput("distPlot")),
        column(6, plotOutput("FuturePlot")))
    )
  )
)

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

opencpu_rnorm <- function(n = 100, mean = 50, sd = 100){
  payload <- list(
    n = n,
    mean = mean,
    sd = sd
  )
  payload <- toJSON(payload, auto_unbox = TRUE)
  res <- httr::POST(
    url = "https://cloud.opencpu.org/ocpu/library/stats/R/rnorm/json", 
    httr::add_headers( 'Content-Type' =  "application/json"),
    body = payload
  )
  result <- unlist(content(res))
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

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  plotValuesPromise <- shinyWorker("plotValuesPromise", function(args) {
      Sys.sleep(5)
      cbind(opencpu_rnorm(mean = 80), opencpu_rnorm(mean = 10))
    }, 
    args_reactive = reactive({
      input$triggerButton
      print("triggered!")
      ""
    })
  )
  
  output$FuturePlot <- renderPlot({
    x <- plotValuesPromise()
    title <- if (is.null(x)) "Job is running..." else "There you go"
    points <- if (is.null(x)) cbind(c(0), c(0)) else x
    plot(points, main = title)
  })
  
}

shinyApp(ui = ui, server = server)
