<a href='https://github.com/Appsilon/shiny.worker'><img src='man/figures/hex.png' align="right" height="150" /></a>

# shiny.worker

`shiny.worker` allows you to delegate heavy computation tasks to a separate process,
such that it does not freeze your Shiny app.

## How to install?

```
remotes::install_github("Appsilon/shiny.worker")
```

## How to use it?

Initialise your worker at the beggining of your app.

```r
worker <- initialize_worker()
```

Then in the server of your Shiny app define a promise that returns a reactive when your heavy job will be completed.

```r

my_heavy_calculations <- function(args) {
  # ...
  args
}

reactive_arguments <- reactive({ # this reactive object is used to trigger the job start, but also passes parameters to the function
  input$start
  list(a = 1, b = 3)
})

resultPromise <- worker$run_job("job1", my_heavy_calculations, args_reactive = reactive_arguments)
```

See examples in the `examples/` folder.


## Appsilon Data Science

Get in touch [dev@appsilon.com](dev@appsilon.com)

