import datetime
import time

MAX_ITERATIONS = 10


def log_msg(msg):
    print(f"{datetime.datetime.utcnow()} - {msg}")


def task_to_run():
    """
    This is the function that could be scheduled with `crontab` on Linux.
    As an alternative the Docker image/container for this Python script
    can be scheduled as a Kubernetes CronJob.
    """
    log_msg("Start working")
    for idx in range(1, MAX_ITERATIONS + 1):
        log_msg(f"...still working, IDX: {idx:02d} out of {MAX_ITERATIONS}")
        time.sleep(1)
    log_msg("Stop working")


if __name__ == "__main__":
    task_to_run()
