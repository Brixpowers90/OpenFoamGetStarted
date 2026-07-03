# OpenFOAM Docker - Getting Started Guide

This guide will help you get started with OpenFOAM using Docker, from installation to running your first simulation.

---

## **📌 Prerequisites**

- **Docker Desktop** installed and running on your machine.
  - [Download Docker Desktop for Windows/macOS](https://www.docker.com/products/docker-desktop/)
  - [Install Docker Engine for Linux](https://docs.docker.com/engine/install/)

---

## **🚀 Step 1: Install OpenFOAM with Docker**

### **Windows**
1. Open **PowerShell** as Administrator.
2. Navigate to the directory containing the installation script:
   ```powershell
   cd C:\path\to\OpenFoamGetStarted
   ```
3. Run the installation script:
   ```powershell
   .\install_openfoam_docker.ps1
   ```
4. Follow the prompts to install Docker (if not already installed) and start the OpenFOAM container.

### **macOS/Linux**
1. Open **Terminal**.
2. Navigate to the directory containing the installation script:
   ```bash
   cd /path/to/OpenFoamGetStarted
   ```
3. Make the script executable:
   ```bash
   chmod +x install_openfoam_docker.sh
   ```
4. Run the installation script:
   ```bash
   ./install_openfoam_docker.sh
   ```
5. Follow the prompts to install Docker (if not already installed) and start the OpenFOAM container.

---

## **🧪 Step 2: Run a Test Case (icoFoam)**

Once the OpenFOAM container is running, you can run a simple test case to verify everything is working.

### **Inside the Docker Container**
1. The container will start with an interactive shell. You are now inside the OpenFOAM environment.
2. Run the test case script:
   ```bash
   /run_test_case.sh
   ```
3. Follow the prompts to create and run the `icoFoam` test case.

### **What the Test Case Does**
- Creates a simple 2D pipe flow simulation.
- Runs `blockMesh` to generate the mesh.
- Runs `icoFoam` to simulate incompressible flow.
- Outputs results to `/home/openfoam/cases/test_icoFoam`.

---

## **📊 Step 3: Visualize Results in ParaView**

OpenFOAM results can be visualized using **ParaView**, which is included in the Docker container.

### **Option 1: Use ParaView Inside the Container**
1. Inside the Docker container, run:
   ```bash
   paraFoam
   ```
2. In ParaView, open the case directory:
   - Navigate to `/home/openfoam/cases/test_icoFoam`.
   - Select the `test_icoFoam.foam` file and click **Apply**.
3. Visualize the results (e.g., velocity field, pressure).

### **Option 2: Use ParaView on Your Host Machine**
1. **Copy the case directory** from the Docker container to your host machine:
   - The case is already saved in the mounted directory (`~/OpenFOAM_cases` on macOS/Linux or `%USERPROFILE%\OpenFOAM_cases` on Windows).
2. **Open ParaView** on your host machine.
3. **Load the case**:
   - Navigate to the `test_icoFoam` directory in your `OpenFOAM_cases` folder.
   - Select the `test_icoFoam.foam` file and click **Apply**.
4. **Visualize the results**:
   - Use the **Pipeline Browser** to add filters (e.g., **Slice**, **Stream Tracer**).
   - Color the mesh by **U** (velocity) or **p** (pressure).

---

## **📂 Step 4: Create Your Own Simulation**

### **1. Create a New Case Directory**
Inside the Docker container:
```bash
mkdir -p /home/openfoam/cases/my_case
cd /home/openfoam/cases/my_case
```

### **2. Copy a Tutorial Case (Optional)**
OpenFOAM includes many tutorial cases. Copy one to use as a template:
```bash
cp -r /opt/openfoam/tutorials/incompressible/icoFoam/cavity .
```

### **3. Modify the Case Files**
Edit the case files (e.g., `0/U`, `0/p`, `system/controlDict`) using a text editor like `nano` or `vim`:
```bash
nano 0/U
```

### **4. Run the Simulation**
```bash
blockMesh  # Generate the mesh
icoFoam    # Run the solver
```

### **5. Monitor the Simulation**
- Use `tail` to monitor the solver output:
  ```bash
  tail -f log.icoFoam
  ```
- Press `Ctrl+C` to stop monitoring.

---

## **🔧 Step 5: Common Commands**

| Command | Description |
|---------|-------------|
| `blockMesh` | Generate the mesh from `blockMeshDict`. |
| `icoFoam` | Run the incompressible flow solver. |
| `paraFoam` | Start ParaView to visualize results. |
| `foamCleanTutorials` | Clean up tutorial files. |
| `simpleFoam` | Run the steady-state solver for incompressible flow. |
| `pimpleFoam` | Run the transient solver for incompressible flow. |

---

## **📚 Step 6: Learn More**

### **OpenFOAM Documentation**
- [OpenFOAM Official Documentation](https://www.openfoam.com/documentation/)
- [OpenFOAM User Guide](https://doc.cfd.direct/openfoam/user-guide/)
- [OpenFOAM Tutorials](https://www.openfoam.com/documentation/tutorials/)

### **Docker Commands**
| Command | Description |
|---------|-------------|
| `docker ps` | List running containers. |
| `docker ps -a` | List all containers (including stopped ones). |
| `docker images` | List Docker images. |
| `docker start openfoam-v2412` | Start a stopped container. |
| `docker attach openfoam-v2412` | Attach to a running container. |
| `docker exec -it openfoam-v2412 bash` | Open a new shell in the container. |

---

## **🛑 Step 7: Stop and Restart the Container**

### **Stop the Container**
1. Press `Ctrl+D` or type `exit` to exit the container shell.
2. The container will stop automatically (due to `--rm` flag).

### **Restart the Container**
To restart the container and access your cases:
```bash
# Windows (PowerShell)
docker run -it --rm --name openfoam-v2412 -v "$env:USERPROFILE\OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412

# macOS/Linux (Bash)
docker run -it --rm --name openfoam-v2412 -v "$HOME/OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412
```

---

## **💡 Tips and Tricks**

### **1. Mount Additional Directories**
To mount additional directories from your host machine:
```bash
docker run -it --rm -v "$HOME/my_cases:/home/openfoam/my_cases" openfoam/openfoam:v2412
```

### **2. Use GPU Acceleration**
If your system has an NVIDIA GPU, you can enable GPU support:
```bash
docker run -it --rm --gpus all openfoam/openfoam:v2412
```

### **3. Run in Detached Mode**
To run the container in the background:
```bash
docker run -d --name openfoam-v2412 -v "$HOME/OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412
```
Then attach to it later:
```bash
docker attach openfoam-v2412
```

### **4. Share Files Between Host and Container**
- Files in the mounted directory (`~/OpenFOAM_cases`) are shared between your host and the container.
- Edit files on your host machine and run simulations in the container.

---

## **❓ Troubleshooting**

### **1. Docker Not Running**
- **Windows/macOS**: Ensure Docker Desktop is running.
- **Linux**: Start the Docker service:
  ```bash
  sudo systemctl start docker
  ```

### **2. Permission Issues**
- Ensure your user has permission to run Docker:
  ```bash
  sudo usermod -aG docker $USER
  ```
  Then log out and log back in.

### **3. OpenFOAM Command Not Found**
- Ensure you are inside the Docker container. Run:
  ```bash
  docker exec -it openfoam-v2412 bash
  ```

### **4. ParaView Not Working**
- If ParaView crashes, try running it with software rendering:
  ```bash
  paraFoam -mesa
  ```

### **5. Out of Memory**
- Increase Docker's memory allocation in Docker Desktop settings.

---

## **🎉 Next Steps**

Now that you have OpenFOAM running:
1. **Try more tutorials**: Explore the cases in `/opt/openfoam/tutorials`.
2. **Modify existing cases**: Change boundary conditions, mesh, or solver settings.
3. **Create your own cases**: Start from scratch or copy a tutorial case.
4. **Automate workflows**: Use Python scripts to pre-process or post-process data.

---

## **📞 Support**

If you encounter issues:
- Check the [OpenFOAM Docker GitHub](https://github.com/OpenFOAM/OpenFOAM-docker) for known issues.
- Ask for help on the [OpenFOAM Discourse Forum](https://discourse.openfoam.com/).
- Consult the [OpenFOAM Wiki](https://openfoamwiki.net/).
