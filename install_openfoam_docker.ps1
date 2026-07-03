#!/usr/bin/env powershell
# OpenFOAM Docker Installation Script for Windows
# This script installs and runs OpenFOAM in a Docker container.
# It prompts the user for confirmation before making changes.

# Requires: PowerShell 5.1 or later

# Function to check if Docker is installed
function Test-DockerInstalled {
    try {
        $dockerVersion = docker --version
        if ($dockerVersion -match "Docker version") {
            return $true
        }
    } catch {
        return $false
    }
    return $false
}

# Function to check if Docker Desktop is running
function Test-DockerRunning {
    try {
        $dockerInfo = docker info
        if ($dockerInfo -match "Server Version") {
            return $true
        }
    } catch {
        return $false
    }
    return $false
}

# Function to prompt user for Docker installation
function Prompt-DockerInstallation {
    Write-Host "" -ForegroundColor Yellow
    Write-Host "Docker is not installed or not running." -ForegroundColor Yellow
    Write-Host "OpenFOAM requires Docker to run in a container." -ForegroundColor Yellow
    Write-Host "" -ForegroundColor Yellow
    Write-Host "To install Docker Desktop:" -ForegroundColor Cyan
    Write-Host "1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Cyan
    Write-Host "2. Run the installer and follow the instructions." -ForegroundColor Cyan
    Write-Host "3. Ensure Docker Desktop is running before continuing." -ForegroundColor Cyan
    Write-Host "" -ForegroundColor Yellow
    
    $choice = Read-Host "Do you want to install Docker Desktop now? (Y/N)"
    if ($choice -eq "Y" -or $choice -eq "y") {
        Start-Process "https://www.docker.com/products/docker-desktop/"
        Write-Host "Please install Docker Desktop and restart this script." -ForegroundColor Yellow
        exit 1
    } else {
        Write-Host "Docker is required to run OpenFOAM. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Function to prompt user to start Docker
function Prompt-StartDocker {
    Write-Host "" -ForegroundColor Yellow
    Write-Host "Docker Desktop is installed but not running." -ForegroundColor Yellow
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Yellow
    Write-Host "" -ForegroundColor Yellow
    
    $choice = Read-Host "Do you want to start Docker Desktop now? (Y/N)"
    if ($choice -eq "Y" -or $choice -eq "y") {
        try {
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            Write-Host "Starting Docker Desktop... Please wait and restart this script." -ForegroundColor Yellow
            exit 1
        } catch {
            Write-Host "Could not start Docker Desktop automatically. Please start it manually." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Docker Desktop must be running. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Function to run OpenFOAM in Docker
function Run-OpenFOAMContainer {
    Write-Host "" -ForegroundColor Green
    Write-Host "Starting OpenFOAM Docker container..." -ForegroundColor Green
    Write-Host "" -ForegroundColor Green
    
    # Create a directory for OpenFOAM cases on the host
    $hostCasesDir = Join-Path $env:USERPROFILE "OpenFOAM_cases"
    if (-not (Test-Path $hostCasesDir)) {
        New-Item -ItemType Directory -Path $hostCasesDir | Out-Null
        Write-Host "Created directory: $hostCasesDir" -ForegroundColor Cyan
    }
    
    # Run OpenFOAM container with interactive terminal and mounted volume
    Write-Host "Running OpenFOAM v2412 in Docker..." -ForegroundColor Cyan
    Write-Host "Your cases will be saved in: $hostCasesDir" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor Green
    
    docker run -it --rm \
        --name openfoam-v2412 \
        -v "${hostCasesDir}:/home/openfoam/cases" \
        -p 1234:1234 \
        openfoam/openfoam:v2412
    
    Write-Host "" -ForegroundColor Green
    Write-Host "OpenFOAM container stopped." -ForegroundColor Green
}

# Function to prompt user to run test case
function Prompt-RunTestCase {
    Write-Host "" -ForegroundColor Yellow
    Write-Host "OpenFOAM is now ready to use!" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor Yellow
    
    $choice = Read-Host "Do you want to run a test case (icoFoam) to verify the installation? (Y/N)"
    if ($choice -eq "Y" -or $choice -eq "y") {
        Write-Host "" -ForegroundColor Cyan
        Write-Host "To run the test case:" -ForegroundColor Cyan
        Write-Host "1. Inside the Docker container, run: /run_test_case.sh" -ForegroundColor Cyan
        Write-Host "2. Follow the instructions to verify OpenFOAM is working." -ForegroundColor Cyan
        Write-Host "" -ForegroundColor Yellow
        
        $confirm = Read-Host "Start the OpenFOAM container now? (Y/N)"
        if ($confirm -eq "Y" -or $confirm -eq "y") {
            Run-OpenFOAMContainer
        }
    } else {
        Write-Host "" -ForegroundColor Green
        Write-Host "OpenFOAM is ready. To start a container, run this script again or use:" -ForegroundColor Green
        Write-Host "docker run -it --rm -v %USERPROFILE%\OpenFOAM_cases:/home/openfoam/cases openfoam/openfoam:v2412" -ForegroundColor Cyan
    }
}

# Main script execution
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "OpenFOAM Docker Installation Script for Windows" -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "" -ForegroundColor White

# Check if Docker is installed
if (-not (Test-DockerInstalled)) {
    Prompt-DockerInstallation
} else {
    # Check if Docker is running
    if (-not (Test-DockerRunning)) {
        Prompt-StartDocker
    }
}

# Pull the OpenFOAM Docker image
Write-Host "Checking for OpenFOAM Docker image..." -ForegroundColor Cyan
try {
    $imageStatus = docker images | Select-String "openfoam/openfoam"
    if (-not $imageStatus) {
        Write-Host "Downloading OpenFOAM v2412 Docker image..." -ForegroundColor Cyan
        docker pull openfoam/openfoam:v2412
    }
} catch {
    Write-Host "Failed to pull Docker image. Check your internet connection." -ForegroundColor Red
    exit 1
}

# Prompt user to run test case
Prompt-RunTestCase

Write-Host "" -ForegroundColor Green
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "" -ForegroundColor White
