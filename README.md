Demonstration of how we can wait for group of tasks before starting other parts.

1. child 1 starts and the task group starts immediately
2. as soon as the task group completed, child 4 starts and finishes immediately

```shell
$ mix run --no-halt
# ... sleeps 1s
Completed 1
# ... sleeps 1s
Completed 2
# ... sleeps 1s
Completed 3
Finished waiting
Completed 4
```
