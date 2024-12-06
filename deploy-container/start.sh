#!/bin/bash

# Function to check CPU usage
check_cpu_usage() {
  # Get the average CPU load percentage over 1 minute
  CPU_USAGE=$(awk '{print $1}' /proc/loadavg)
  MAX_CPU_LOAD=80.0  # Set your threshold, e.g., 80%

  # Compare CPU load with threshold
  if (( $(echo "$CPU_USAGE > $MAX_CPU_LOAD" | bc -l) )); then
    echo "High CPU usage detected: $CPU_USAGE%. Restarting bot..."
    return 1  # Signal that CPU is too high
  fi

  return 0  # CPU usage is acceptable
}

# Infinite loop to restart the bot
while true; do
  echo "Starting the bot..."
  node start.js  # Replace this with the actual command to start your bot

  EXIT_CODE=$?
  echo "Bot exited with code: $EXIT_CODE"

  if [ $EXIT_CODE -ne 0 ]; then
    echo "Bot crashed or encountered an error. Restarting..."
  fi

  # Check CPU usage and restart if it's too high
  if ! check_cpu_usage; then
    echo "Restarting due to high CPU usage..."
  fi

  echo "Restarting bot in 5 seconds..."
  sleep 5  # Add a delay before restarting
done
