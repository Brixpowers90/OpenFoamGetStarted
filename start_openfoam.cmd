@echo off
REM OpenFOAM Docker Starter - No Admin Rights Required
REM This script starts an OpenFOAM container with your cases folder mounted
REM Usage: Just double-click this file

REM Check if Docker is running
echo Checking Docker status...
docker --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Docker is not installed or not running.
    echo Please install Docker Desktop first: https://www.docker.com/products/docker-desktop/
    echo Then start Docker Desktop and try again.
    pause
    exit /b 1
)

echo Docker is running. Starting OpenFOAM container...
echo.

REM Create OpenFOAM_cases folder if it doesn't exist
if not exist "%USERPROFILE%\Documents\OpenFOAM_cases" (
    mkdir "%USERPROFILE%\Documents\OpenFOAM_cases"
    echo Created folder: %USERPROFILE%\Documents\OpenFOAM_cases
)

echo Starting OpenFOAM v2412 container...
echo Your cases will be saved in: %USERPROFILE%\Documents\OpenFOAM_cases
echo.
echo To exit the container, type: exit
echo.

REM Start the container with volume mount
docker run -it --name my-openfoam -v "%USERPROFILE%\Documents\OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412

echo.
echo Container stopped. Your files are safe in %USERPROFILE%\Documents\OpenFOAM_cases
pause
