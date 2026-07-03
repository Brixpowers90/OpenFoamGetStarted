# OpenFOAM Dockerfile (Optional)
# This Dockerfile builds a custom OpenFOAM image with additional tools.
# Use this if you need to extend the official OpenFOAM image.

# Start from the official OpenFOAM image
FROM openfoam/openfoam:v2412

# Set the working directory
WORKDIR /home/openfoam

# Install additional tools (e.g., Python, Vim, Git)
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        vim \
        git \
        gnuplot \
        && rm -rf /var/lib/apt/lists/*

# Install Python packages for post-processing
RUN pip3 install numpy pandas matplotlib

# Copy the test case script into the container
COPY run_test_case.sh /run_test_case.sh

# Make the test case script executable
RUN chmod +x /run_test_case.sh

# Create a directory for cases
RUN mkdir -p /home/openfoam/cases

# Set environment variables
ENV FOAM_RUN=/home/openfoam/cases

# Default command: start an interactive shell
CMD ["/bin/bash"]
