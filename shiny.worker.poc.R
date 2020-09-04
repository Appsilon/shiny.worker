library(future)
library(shiny)

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
      cbind(rnorm(1000), rnorm(1000))
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
