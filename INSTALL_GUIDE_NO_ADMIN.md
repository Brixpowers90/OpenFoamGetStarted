# OpenFOAM Installation Guide - No Admin Rights Required

This guide helps you install and run OpenFOAM using Docker **without requiring administrator privileges or PowerShell scripts**. Perfect for corporate environments with restricted access.

---

## **✅ What You Need**

1. **Docker Desktop** installed on your machine
2. **Internet access** to download Docker images
3. **Basic file navigation** skills

---

## **📋 Step 1: Install Docker Desktop**

### **Check if Docker is Already Installed**
Open Command Prompt (cmd) and type:
```cmd
docker --version
```

- If you see a version number (e.g., `Docker version 24.0.7`), Docker is already installed. **Skip to Step 2**.
- If you see `'docker' is not recognized...`, you need to install Docker.

### **Download and Install Docker Desktop**

#### **For Windows 10/11:**
1. **Download Docker Desktop**: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. **Run the installer** (`.exe` file you downloaded)
3. **Follow the installation prompts**
4. **Restart your computer** when prompted
5. **Launch Docker Desktop** from the Start Menu
6. **Wait for Docker to start** (you'll see a whale icon in the system tray)

#### **For macOS:**
1. **Download Docker Desktop**: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. **Open the `.dmg` file** and drag Docker to Applications
3. **Launch Docker Desktop** from Applications
4. **Wait for Docker to start** (whale icon in menu bar)

#### **For Linux:**
If you're on Linux, ask your IT department to install Docker Engine:
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

---

## **🐳 Step 2: Download OpenFOAM Docker Image**

Open **Command Prompt** (Windows) or **Terminal** (macOS/Linux) and run:

```cmd
docker pull openfoam/openfoam:v2412
```

**What this does:**
- Downloads the latest OpenFOAM v2412 image (~2-3 GB)
- Includes OpenFOAM, ParaView, and all dependencies
- May take 5-15 minutes depending on your internet speed

**Expected output:**
```
v2412: Pulling from openfoam/openfoam
Digest: sha256:...
Status: Downloaded newer image for openfoam/openfoam:v2412
```

---

## **🚀 Step 3: Start OpenFOAM Container**

### **Create a folder for your cases**
1. Open File Explorer (Windows) or Finder (macOS)
2. Create a new folder called `OpenFOAM_cases` in your **Documents** folder

### **Start the container with your cases folder mounted**

#### **Windows (Command Prompt):**
```cmd
docker run -it --name my-openfoam -v "%USERPROFILE%\Documents\OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412
```

#### **macOS/Linux (Terminal):**
```bash
docker run -it --name my-openfoam -v "$HOME/Documents/OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412
```

**What this does:**
- Starts an OpenFOAM container
- Mounts your `OpenFOAM_cases` folder so files persist after container exit
- Gives you an interactive shell inside the container

**Expected output:**
```
root@container-id:/home/openfoam#
```

---

## **🧪 Step 4: Run Your First Simulation**

Now you're inside the OpenFOAM container! Let's run a simple test case.

### **Create a test case directory:**
```bash
mkdir -p /home/openfoam/cases/test_icoFoam
cd /home/openfoam/cases/test_icoFoam
```

### **Create the mesh (blockMeshDict):**
```bash
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
        faces           ((1 2 6 5));
    }
    walls
    {
        type            wall;
        faces           ((0 1 5 4) (3 7 6 2));
    }
    frontAndBack
    {
        type            empty;
        faces           ((0 3 2 1) (4 5 6 7));
    }
);

mergePatchPairs
(
);
EOF
```

### **Create the initial fields (0 directory):**
```bash
mkdir -p 0
```

### **Create velocity file (0/U):**
```bash
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
    frontAndBack
    {
        type            empty;
    }
}
EOF
```

### **Create pressure file (0/p):**
```bash
cat > 0/p << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       volScalarField;
    object      p;
}

dimensions      [1 -1 -2 0 0 0 0];

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
    frontAndBack
    {
        type            empty;
    }
}
EOF
```

### **Create transport properties (constant/transportProperties):**
```bash
mkdir -p constant
cat > constant/transportProperties << 'EOF'
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      transportProperties;
}

transportModel  Newtonian;

nu              nu [0 2 -1 0 0 0 0] 0.01;
EOF
```

### **Create solver settings (system/controlDict):**
```bash
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

deltaT          0.01;

writeControl    timeStep;

writeInterval   10;

purgeWrite      0;

runTimeModifiable true;

libraries       ("libOpenFOAM.so");
EOF
```

### **Create numerical schemes (system/fvSchemes):**
```bash
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
    div(rho*phi,U)  bounded Gauss linearUpwind grad(U);
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
```

### **Create solution settings (system/fvSolution):**
```bash
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
        tolerance       1e-6;
        relTol          0.01;
    }
    U
    {
        solver          smoothSolver;
        smoother        symGaussSeidel;
        tolerance       1e-6;
        relTol          0.01;
    }
}

SIMPLE
{
    nNonOrthogonalCorrectors 0;
    consistent      yes;
    pRefCell        0;
    pRefValue       0;
}

relaxationFactors
{
    equations
    {
        U               0.7;
        p               0.3;
    }
}
EOF
```

### **Run the simulation:**
```bash
blockMesh
icoFoam
```

**What this does:**
- `blockMesh` creates the computational mesh
- `icoFoam` runs the incompressible flow solver
- Simulation runs for 0.5 seconds with time step 0.01

**Expected output:**
```
Creating mesh... Done.
Starting icoFoam...
Time = 0.01
Time = 0.02
...
Time = 0.5
End
```

---

## **📊 Step 5: Visualize Results**

### **Option 1: Use ParaView Inside Container**
Inside the container, run:
```bash
paraFoam
```
- Navigate to `/home/openfoam/cases/test_icoFoam`
- Open the `test_icoFoam.foam` file
- Click **Apply** to see your simulation results

### **Option 2: Use ParaView on Your Host Machine**
1. **Download ParaView**: [https://www.paraview.org/download/](https://www.paraview.org/download/)
2. **Install ParaView** on your machine
3. **Open ParaView**
4. **Load your case**:
   - Navigate to `Documents\OpenFOAM_cases\test_icoFoam` (Windows)
   - Or `~/Documents/OpenFOAM_cases/test_icoFoam` (macOS/Linux)
   - Select the `test_icoFoam.foam` file
   - Click **Apply**
5. **Visualize**:
   - In the Pipeline Browser, click on `test_icoFoam.foam`
   - Click the **Play** button to animate the flow
   - Use the toolbar to add **Slice** or **Stream Tracer** filters
   - Color by **U** (velocity) or **p** (pressure)

---

## **🔄 Step 6: Stop and Restart Container**

### **Exit the container (without deleting it):**
Press `Ctrl+D` or type `exit`

### **Restart your container later:**

#### **Windows (Command Prompt):**
```cmd
docker start -ai my-openfoam
```

#### **macOS/Linux (Terminal):**
```bash
docker start -ai my-openfoam
```

### **Stop the container:**
```cmd
docker stop my-openfoam
```

---

## **📝 Quick Reference Commands**

| Action | Command |
|--------|---------|
| Start container | `docker start -ai my-openfoam` |
| Stop container | `docker stop my-openfoam` |
| Remove container | `docker rm my-openfoam` |
| List containers | `docker ps -a` |
| List images | `docker images` |
| Open shell in container | `docker exec -it my-openfoam bash` |
| Copy files from container | `docker cp my-openfoam:/path/in/container /path/on/host` |

---

## **🎯 Next Steps**

1. **Try more tutorials**: Copy cases from `/opt/openfoam/tutorials`
2. **Modify the test case**: Change boundary conditions in `0/U` or `0/p`
3. **Create your own cases**: Start from scratch or copy existing ones
4. **Explore OpenFOAM documentation**: [https://www.openfoam.com/documentation/](https://www.openfoam.com/documentation/)

---

## **❓ Troubleshooting**

### **Docker not running?**
- **Windows/macOS**: Make sure Docker Desktop is running (whale icon visible)
- **Linux**: Run `sudo systemctl start docker`

### **Permission denied?**
- On Linux, add your user to the docker group:
  ```bash
  sudo usermod -aG docker $USER
  ```
  Then **log out and log back in**

### **Can't access files after container exit?**
- Your files are safe in `Documents\OpenFOAM_cases`
- Just restart the container with the same `-v` volume mount

### **ParaView not working in container?**
- Use ParaView on your host machine instead
- Make sure your case files are in the mounted volume

### **Out of memory?**
- In Docker Desktop: Settings → Resources → Increase memory allocation

---

## **📚 Additional Resources**

- [OpenFOAM Official Documentation](https://www.openfoam.com/documentation/)
- [OpenFOAM Docker Images](https://hub.docker.com/u/openfoam)
- [OpenFOAM Tutorials](https://www.openfoam.com/documentation/tutorials/)
- [ParaView Download](https://www.paraview.org/download/)
- [Docker Documentation](https://docs.docker.com/)

---

## **💡 Tips for Corporate Environments**

1. **Proxy settings**: If your company uses a proxy, configure Docker to use it:
   - Windows: Docker Desktop → Settings → Resources → Proxies
   - macOS: Docker Desktop → Preferences → Resources → Proxies

2. **Storage location**: If C: drive is full, change Docker's storage location:
   - Docker Desktop → Settings → Resources → Advanced → Disk image location

3. **Firewall**: If Docker can't connect, ask IT to allow:
   - Outbound connections to `hub.docker.com` (port 443)
   - Docker's network traffic

4. **Antivirus**: Some antivirus software may slow down Docker. Ask IT to add exceptions for:
   - Docker Desktop
   - Docker's virtual machine files

---

## **🧹 Cleanup (When Needed)**

### **Remove the container:**
```cmd
docker rm my-openfoam
```

### **Remove the Docker image:**
```cmd
docker rmi openfoam/openfoam:v2412
```

### **Remove all unused Docker objects:**
```cmd
docker system prune
```

---

**🎉 Congratulations!** You now have OpenFOAM running and have completed your first simulation!
