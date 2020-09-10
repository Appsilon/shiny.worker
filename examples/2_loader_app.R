library(shiny)
library(shiny.worker)

worker <- initialize_worker()

loader_css <- "
#spinner {
display: inline-block;
border: 3px solid #f3f3f3;
border-top: 3px solid #3498db;
border-radius: 50%;
width: 40px;
height: 40px;
animation: spin 1s ease-in-out infinite;
}
@keyframes spin {
0% { transform: rotate(0deg); }
100% { transform: rotate(360deg); }
}"

ui <- fluidPage(
  tags$style(loader_css),
  # Application title
  titlePanel("shiny.worker demo with loader"),

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
        column(6,
               uiOutput("loader"),
               plotOutput("FuturePlot")))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })

  plotValuesPromise <- worker$run_job("plotValuesPromise", function(args) {
    Sys.sleep(5)
    cbind(rnorm(1000), rnorm(1000))
  },
  args_reactive = reactive({
    input$triggerButton
    print("triggered!")
    ""
  })
  )

  output$loader <- renderUI({
    task <- plotValuesPromise()
    if (!task$resolved) {
      div(
        div(class = "loader-text", "Job is running..."),
        div(id = "spinner")
      )
    }
  })

  output$FuturePlot <- renderPlot({
    task <- plotValuesPromise()
    if (task$resolved) {
      plot(task$result, main = "There you go")
    }
  })

}

shinyApp(ui = ui, server = server)
