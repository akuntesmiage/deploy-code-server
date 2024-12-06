# Start from the code-server Debian base image
FROM codercom/code-server:4.9.0

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install -y unzip bc  # `bc` needed for CPU comparison
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Add the start script for the bot
COPY deploy-container/start.sh /usr/bin/start.sh

# Ensure the script is executable
RUN chmod +x /usr/bin/start.sh

# Environment variable for bot port
ENV PORT=8080

# Use the start script as the entrypoint
ENTRYPOINT ["/usr/bin/start.sh"]
