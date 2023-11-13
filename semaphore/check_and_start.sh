#!/bin/sh

# Function to format the date and time
get_formatted_date() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')"
}

# Read container names from the environment variable
IFS=',' read -ra containers <<< "$CONTAINER_NAMES"


while true; do
    # Your action or command goes here
    echo "Running at $(get_formatted_date)"

    # Check if contairner is running
    if [ "$(docker inspect -f '{{.State.Running}}' $CONTAINER_TO_CHECK_VOL 2>/dev/null)" != "true" ]; then
        echo "$(get_formatted_date) - Container $CONTAINER_TO_CHECK_VOL is not running. Exiting..."
        break
    fi

    # Check if the folder exists in the container
    if docker exec "$CONTAINER_TO_CHECK_VOL" test -d "$REQUIRED_FOLDER"; then
        # Once required folder exists, Check and start containers in a loop
        for container in "${containers[@]}"; do
            if [ "$(docker inspect -f '{{.State.Running}}' "$container" 2>/dev/null)" != "true" ]; then
                echo "$(get_formatted_date) - Container $container is not running. Starting..."
                docker start "$container"
            fi
        done
        echo "$(get_formatted_date) - All containers: $CONTAINER_NAMES are running."
    else
        echo "$(get_formatted_date) - Waiting for the folder $REQUIRED_FOLDER to be ready..."
    fi
    # Sleep for one minute before the next iteration
    sleep $TIMER_SECONDS
done