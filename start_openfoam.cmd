@echo off
REM OpenFOAM Docker Starter - No Admin Rights Required
REM This script starts an OpenFOAM container with your cases folder mounted
REM Usage: Just double-click this file
REM 
REM Recommended image: opencfd/openfoam-default (456 MB, faster download)
REM Alternative image: openfoam/openfoam:v2412 (2-3 GB, includes ParaView)

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

echo Docker is running.

REM Create OpenFOAM_cases folder if it doesn't exist
if not exist "%USERPROFILE%\Documents\OpenFOAM_cases" (
    mkdir "%USERPROFILE%\Documents\OpenFOAM_cases"
    echo Created folder: %USERPROFILE%\Documents\OpenFOAM_cases
)

echo.
echo ============================================
echo OpenFOAM Docker Starter
echo ============================================
echo.
echo Choose an image:
echo 1. opencfd/openfoam-default (RECOMMENDED - 456 MB, faster)
echo 2. openfoam/openfoam:v2412 (2-3 GB, includes ParaView)
echo.

set /p choice=Enter your choice (1 or 2):

if "%choice%"=="2" (
    set IMAGE=openfoam/openfoam:v2412
    echo Starting OpenFOAM v2412 container with ParaView...
) else (
    set IMAGE=opencfd/openfoam-default
    echo Starting opencfd/openfoam-default container (RECOMMENDED)...
)

echo.
echo Your cases will be saved in: %USERPROFILE%\Documents\OpenFOAM_cases
echo.
echo To exit the container, type: exit
echo.
echo Downloading image if not already present...

REM Start the container with volume mount
docker run -it --name my-openfoam -v "%USERPROFILE%\Documents\OpenFOAM_cases:/home/openfoam/cases" %IMAGE%

echo.
echo Container stopped. Your files are safe in %USERPROFILE%\Documents\OpenFOAM_cases
pause
