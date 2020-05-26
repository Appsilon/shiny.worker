library(rworker)
library(magrittr)

# Broker url
redis_url <- 'redis://localhost:6379'

# Instantiate Rworker object
consumer <- rworker(name='celery', workers=12, queue=redis_url, backend=redis_url)

# Register tasks
(function(x){
  for(i in 1:5) {
    Sys.sleep(1)
    task_progress(i*10)
  }
  x * 5
}) %>% consumer$task(name='long_running_task')

# Start consuming messages
consumer$consume()