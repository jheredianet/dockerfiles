FROM alpine:latest
LABEL maintainer="@jheredianet"

# Install necessary tools (e.g., docker-cli)
RUN apk --no-cache add docker-cli bash

# Copy your script into the container
COPY check_and_start.sh /check_and_start.sh

# Set execute permissions on the script
RUN chmod +x /check_and_start.sh

ENV TIMER_SECONDS=60
ENV CONTAINER_NAMES="container1,container2,container3"
ENV CONTAINER_TO_CHECK_VOL="fs-juicefs-1"
ENV REQUIRED_FOLDER="/path_inside_container"

# Define the entry point for the container
ENTRYPOINT ["/check_and_start.sh"]