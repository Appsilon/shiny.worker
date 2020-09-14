library(shiny)
library(shiny.worker)

worker <- initialize_worker()

generate_values <- function(args){
  n <- args$n
  scale <- args$scale
  Sys.sleep(3)
  rnorm(n) * scale
}

ui <- fluidPage(
  titlePanel("shiny.worker arguments passing demo"),
  sidebarLayout(
    sidebarPanel(
      div("Play with the slider. Histogram will be still responsive, even if job is running:"),
      br(),
      sliderInput("bars",
                  "Number of bars:",
                  min = 3,
                  max = 10,
                  value = 5),
      numericInput("scale", "Scale values by:", 2, min = 1, max = 100),
      br(),
      h5("Run new job:"),
      actionButton("triggerButton", "Run job (3 sec.)")
    ),
    mainPanel(
      fluidRow(
        plotOutput("barPlot"))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  values <- reactive({
    input$triggerButton
    print("Triggered...")
    list(n = input$bars, scale = input$scale)
  })
  barplotPromise <- worker$run_job("generateValuesPromise",
                                   generate_values,
                                   args_reactive = values)

  barCache <- reactiveVal(c(0,0))

  output$barPlot <- renderPlot({
    x <- barplotPromise()
    title <- if (is.null(x$result)) "Job is running..." else "There you go"
    if (!is.null(x$result)) {
      barCache(x$result)
    }
    bars <- barCache()
    barplot(bars, main = title)
  })

}

shinyApp(ui = ui, server = server)
