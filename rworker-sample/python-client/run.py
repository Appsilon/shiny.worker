#!/usr/bin/env python3

import time
from celery import Celery

worker = Celery(
    "app", broker="redis://localhost:6379/0", backend="redis://localhost:6379/0"
)

results = [worker.send_task("long_running_task", kwargs={"x": 7}) for _ in range(1)]


while not all([result.ready() for result in results]):
    for result in results:
        print(result.result)
    # print(async_result)
    # print(async_result.ready())
    # print(async_result.result)

    # Check task progress
    # if async_result is not None:
        # print(async_result.info['progress'])

        # # Check task state
        # print(async_result.state)
    time.sleep(1)

print([result.result for result in results])
