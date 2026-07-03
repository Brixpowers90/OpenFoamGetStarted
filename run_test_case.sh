#!/bin/bash
# OpenFOAM Test Case Script (icoFoam)
# This script runs a simple icoFoam test case to verify OpenFOAM is working.
# It should be run INSIDE the OpenFOAM Docker container.

# Function to create a simple icoFoam test case
create_test_case() {
    echo "Creating icoFoam test case in /home/openfoam/cases/test_icoFoam..."
    
    # Create case directory
    mkdir -p /home/openfoam/cases/test_icoFoam
    cd /home/openfoam/cases/test_icoFoam
    
    # Create 0 directory
    mkdir -p 0
    
    # Create constant directory
    mkdir -p constant
    
    # Create system directory
    mkdir -p system
    
    # Create 0/U (velocity field)
    cat > 0/U << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       volVectorField;
    object      U;
}

dimensions      [0 1 -1 0 0 0 0];

internalField   uniform (1 0 0);

boundaryField
{
    inlet
    {
        type            fixedValue;
        value           uniform (1 0 0);
    }
    outlet
    {
        type            zeroGradient;
    }
    walls
    {
        type            noSlip;
    }
}
EOF

    # Create 0/p (pressure field)
    cat > 0/p << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       volScalarField;
    object      p;
}

dimensions      [0 2 -2 0 0 0 0];

internalField   uniform 0;

boundaryField
{
    inlet
    {
        type            zeroGradient;
    }
    outlet
    {
        type            fixedValue;
        value           uniform 0;
    }
    walls
    {
        type            zeroGradient;
    }
}
EOF

    # Create constant/transportProperties
    cat > constant/transportProperties << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      transportProperties;
}

transportModel  Newtonian;

nu              nu [0 2 -1 0 0 0 0] 1e-06;
EOF

    # Create constant/turbulenceProperties (empty for icoFoam)
    cat > constant/turbulenceProperties << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      turbulenceProperties;
}

simulationType  laminar;
EOF

    # Create system/controlDict
    cat > system/controlDict << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      controlDict;
}

application     icoFoam;

startFrom       startTime;

startTime       0;

stopAt          endTime;

endTime         0.5;

deltaT          0.001;

writeControl    timeStep;

writeInterval   10;

purgeWrite      0;

runTimeModifiable true;
EOF

    # Create system/fvSchemes
    cat > system/fvSchemes << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      fvSchemes;
}

ddtSchemes
{
    default         Euler;
}

gradSchemes
{
    default         Gauss linear;
}

divSchemes
{
    default         none;
}

laplacianSchemes
{
    default         Gauss linear corrected;
}

interpolationSchemes
{
    default         linear;
}

snGradSchemes
{
    default         corrected;
}
EOF

    # Create system/fvSolution
    cat > system/fvSolution << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      fvSolution;
}

solvers
{
    p
    {
        solver          GAMG;
        tolerance       1e-06;
        relTol          0.01;
    }
    U
    {
        solver          smoothSolver;
        smoother        symGaussSeidel;
        tolerance       1e-06;
        relTol          0.01;
    }
}

PIMPLE
{
    nOuterCorrectors 1;
    nCorrectors     1;
    nNonOrthogonalCorrectors 0;
}
EOF

    # Create blockMeshDict (simple 2D pipe)
    cat > system/blockMeshDict << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      blockMeshDict;
}

convertToMeters 0.1;

vertices
(
    (0 0 0)
    (1 0 0)
    (1 1 0)
    (0 1 0)
    (0 0 0.1)
    (1 0 0.1)
    (1 1 0.1)
    (0 1 0.1)
);

blocks
(
    hex (0 1 2 3 4 5 6 7) (10 10 1) simpleGrading (1 1 1)
);

edges
(
);

boundary
(
    inlet
    {
        type            patch;
        faces           ((0 4 7 3));
    }
    outlet
    {
        type            patch;
        faces           ((1 5 6 2));
    }
    walls
    {
        type            wall;
        faces           ((0 1 2 3) (4 5 6 7));
    }
);

mergePatchPairs
(
);
EOF

    echo "Test case created successfully!"
}

# Function to run the test case
run_test_case() {
    echo ""
    echo "Running icoFoam test case..."
    echo ""
    
    cd /home/openfoam/cases/test_icoFoam
    
    # Run blockMesh
    echo "Running blockMesh..."
    blockMesh
    
    # Run icoFoam
    echo "Running icoFoam..."
    icoFoam
    
    echo ""
    echo "Test case completed!"
    echo ""
    echo "To view the results in ParaView:"
    echo "1. Start ParaView on your host machine."
    echo "2. Open the case directory: /home/openfoam/cases/test_icoFoam"
    echo "3. Load the case and visualize the results."
    echo ""
    echo "Note: ParaView is also available inside the container. Run 'paraFoam' to start it."
}

# Main script execution
echo "============================================="
echo "OpenFOAM Test Case Script (icoFoam)"
echo "============================================="
echo ""

# Check if we are inside the OpenFOAM container
if [ ! -d "/opt/openfoam" ]; then
    echo -e "\033[31mError: This script must be run INSIDE the OpenFOAM Docker container.\033[0m"
    echo "Start the container first using: docker run -it openfoam/openfoam:v2412"
    exit 1
fi

# Check if test case already exists
if [ -d "/home/openfoam/cases/test_icoFoam" ]; then
    read -p "Test case already exists. Overwrite? (Y/N): " choice
    if [[ "$choice" =~ [Yy] ]]; then
        rm -rf /home/openfoam/cases/test_icoFoam
        create_test_case
    fi
else
    create_test_case
fi

# Ask user if they want to run the test case
read -p "Do you want to run the icoFoam test case now? (Y/N): " choice
if [[ "$choice" =~ [Yy] ]]; then
    run_test_case
else
    echo ""
    echo "To run the test case later, execute:"
    echo "cd /home/openfoam/cases/test_icoFoam && blockMesh && icoFoam"
fi
