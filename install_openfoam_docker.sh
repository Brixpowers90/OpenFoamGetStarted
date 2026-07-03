#!/bin/bash
# OpenFOAM Docker Installation Script for macOS/Linux
# This script installs and runs OpenFOAM in a Docker container.
# It prompts the user for confirmation before making changes.

# Function to check if Docker is installed
check_docker_installed() {
    if command -v docker &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if Docker is running
check_docker_running() {
    if docker info &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to prompt user for Docker installation
prompt_docker_installation() {
    echo ""
    echo -e "\033[33mDocker is not installed or not running.\033[0m"
    echo -e "\033[33mOpenFOAM requires Docker to run in a container.\033[0m"
    echo ""
    echo -e "\033[36mTo install Docker:\033[0m"
    echo -e "\033[36m1. Follow the instructions for your OS:\033[0m"
    echo -e "\033[36m   - macOS: https://docs.docker.com/desktop/install/mac-install/\033[0m"
    echo -e "\033[36m   - Linux: https://docs.docker.com/engine/install/\033[0m"
    echo -e "\033[36m2. Ensure Docker is running before continuing.\033[0m"
    echo ""
    
    read -p "Do you want to install Docker now? (Y/N): " choice
    if [[ "$choice" =~ [Yy] ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "\033[33mOpening Docker Desktop download page...\033[0m"
            open "https://www.docker.com/products/docker-desktop/"
        else
            echo -e "\033[33mPlease install Docker manually and restart this script.\033[0m"
        fi
        exit 1
    else
        echo -e "\033[31mDocker is required to run OpenFOAM. Exiting.\033[0m"
        exit 1
    fi
}

# Function to prompt user to start Docker
prompt_start_docker() {
    echo ""
    echo -e "\033[33mDocker is installed but not running.\033[0m"
    echo -e "\033[33mPlease start Docker and try again.\033[0m"
    echo ""
    
    read -p "Do you want to try starting Docker now? (Y/N): " choice
    if [[ "$choice" =~ [Yy] ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open -a Docker
            echo -e "\033[33mStarting Docker Desktop... Please wait and restart this script.\033[0m"
        else
            echo -e "\033[33mPlease start Docker manually (e.g., 'sudo systemctl start docker').\033[0m"
        fi
        exit 1
    else
        echo -e "\033[31mDocker must be running. Exiting.\033[0m"
        exit 1
    fi
}

# Function to run OpenFOAM in Docker
run_openfoam_container() {
    echo ""
    echo -e "\033[32mStarting OpenFOAM Docker container...\033[0m"
    echo ""
    
    # Create a directory for OpenFOAM cases on the host
    HOST_CASES_DIR="$HOME/OpenFOAM_cases"
    if [ ! -d "$HOST_CASES_DIR" ]; then
        mkdir -p "$HOST_CASES_DIR"
        echo -e "\033[36mCreated directory: $HOST_CASES_DIR\033[0m"
    fi
    
    # Run OpenFOAM container with interactive terminal and mounted volume
    echo -e "\033[36mRunning OpenFOAM v2412 in Docker...\033[0m"
    echo -e "\033[36mYour cases will be saved in: $HOST_CASES_DIR\033[0m"
    echo ""
    
    docker run -it --rm \
        --name openfoam-v2412 \
        -v "$HOST_CASES_DIR:/home/openfoam/cases" \
        -p 1234:1234 \
        openfoam/openfoam:v2412
    
    echo ""
    echo -e "\033[32mOpenFOAM container stopped.\033[0m"
}

# Function to prompt user to run test case
prompt_run_test_case() {
    echo ""
    echo -e "\033[33mOpenFOAM is now ready to use!\033[0m"
    echo ""
    
    read -p "Do you want to run a test case (icoFoam) to verify the installation? (Y/N): " choice
    if [[ "$choice" =~ [Yy] ]]; then
        echo ""
        echo -e "\033[36mTo run the test case:\033[0m"
        echo -e "\033[36m1. Inside the Docker container, run: /run_test_case.sh\033[0m"
        echo -e "\033[36m2. Follow the instructions to verify OpenFOAM is working.\033[0m"
        echo ""
        
        read -p "Start the OpenFOAM container now? (Y/N): " confirm
        if [[ "$confirm" =~ [Yy] ]]; then
            run_openfoam_container
        fi
    else
        echo ""
        echo -e "\033[32mOpenFOAM is ready. To start a container, run this script again or use:\033[0m"
        echo -e "\033[36mdocker run -it --rm -v $HOME/OpenFOAM_cases:/home/openfoam/cases openfoam/openfoam:v2412\033[0m"
    fi
}

# Main script execution
echo "============================================="
echo -e "\033[35mOpenFOAM Docker Installation Script for macOS/Linux\033[0m"
echo "============================================="
echo ""

# Check if Docker is installed
if ! check_docker_installed; then
    prompt_docker_installation
fi

# Check if Docker is running
if ! check_docker_running; then
    prompt_start_docker
fi

# Pull the OpenFOAM Docker image
echo -e "\033[36mChecking for OpenFOAM Docker image...\033[0m"
if ! docker images | grep -q "openfoam/openfoam"; then
    echo -e "\033[36mDownloading OpenFOAM v2412 Docker image...\033[0m"
    docker pull openfoam/openfoam:v2412
fi

# Prompt user to run test case
prompt_run_test_case

echo ""
echo -e "\033[32mInstallation complete!\033[0m"
echo ""
