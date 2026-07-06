# OpenFOAM Docker Agent

A simple agent to install and run **OpenFOAM** on any machine using **Docker**. This project provides multiple installation methods to accommodate different environments, including corporate settings with restricted access.

---

## **\ud83d\udccc Features**

\u2705 **Cross-platform**: Works on **Windows, macOS, and Linux**.
\u2705 **Minimal setup**: Only requires Docker.
\u2705 **Multiple image options**: Choose between small/fast or full-featured images.
\u2705 **ParaView support**: Available in full image or install separately.
\u2705 **Multiple installation methods**: Scripts for different access levels.
\u2705 **Test case**: Verify installation with a simple `icoFoam` simulation.
\u2705 **Uninstall guide**: Easy cleanup of Docker containers and images.

---

## **\ud83d\udc33 Recommended Docker Images**

### **\u2728 opencfd/openfoam-default (RECOMMENDED for Corporate)**
- **Size**: ~456 MB (faster download)
- **Includes**: OpenFOAM runtime, source code, tutorials, development tools
- **ParaView**: Not included (download separately)
- **Best for**: Corporate environments with bandwidth restrictions
- **Docker Hub**: [https://hub.docker.com/r/opencfd/openfoam-default](https://hub.docker.com/r/opencfd/openfoam-default)

### **openfoam/openfoam:v2412 (Alternative)**
- **Size**: ~2-3 GB
- **Includes**: OpenFOAM runtime, ParaView
- **ParaView**: Included
- **Best for**: Users who want built-in visualization
- **Docker Hub**: [https://hub.docker.com/r/openfoam/openfoam](https://hub.docker.com/r/openfoam/openfoam)

---

## **\ud83d\ude80 Quick Start - Choose Your Method**

### **\ud83d\udca1 Method 1: Standard Installation (Full Access)**
For users with full administrative access and PowerShell/Bash capabilities.

#### **1. Clone or Download This Repository**
```bash
git clone https://github.com/Brixpowers90/OpenFoamGetStarted.git
cd OpenFoamGetStarted
```

#### **2. Run the Installation Script**

##### **Windows (PowerShell)**
```powershell
.\install_openfoam_docker.ps1
```

##### **macOS/Linux (Bash)**
```bash
chmod +x install_openfoam_docker.sh
./install_openfoam_docker.sh
```

---

### **\ud83d\udcdd Method 2: No Admin Rights / No PowerShell (Corporate Environments)**
For users with restricted access where PowerShell scripts (.ps1) are blocked.

#### **1. Install Docker Desktop**
- Download from: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- Install and launch Docker Desktop

#### **2. Download OpenFOAM Image**
Open Command Prompt (cmd) and run **ONE** of these:

**Recommended (smaller, faster):**
```cmd
docker pull opencfd/openfoam-default
```

**Alternative (with ParaView):**
```cmd
docker pull openfoam/openfoam:v2412
```

#### **3. Start OpenFOAM**
**Option A**: Double-click `start_openfoam.cmd` in this folder (it will ask you to choose an image)

**Option B**: Open Command Prompt and run ONE of these:

For **recommended** image:
```cmd
docker run -it --name my-openfoam -v "%USERPROFILE%\Documents\OpenFOAM_cases:/home/openfoam/cases" opencfd/openfoam-default
```

For **alternative** image:
```cmd
docker run -it --name my-openfoam -v "%USERPROFILE%\Documents\OpenFOAM_cases:/home/openfoam/cases" openfoam/openfoam:v2412
```

#### **4. Follow the Quick Start Guide**
See [`QUICK_START.txt`](QUICK_START.txt) for step-by-step instructions to run your first simulation.

**Detailed guide**: [`INSTALL_GUIDE_NO_ADMIN.md`](INSTALL_GUIDE_NO_ADMIN.md)

---

## **\ud83d\udcc2 Project Structure**

| File | Description |
|------|-------------|
| [`install_openfoam_docker.ps1`](install_openfoam_docker.ps1) | Windows PowerShell script for standard installation |
| [`install_openfoam_docker.sh`](install_openfoam_docker.sh) | macOS/Linux Bash script for standard installation |
| [`start_openfoam.cmd`](start_openfoam.cmd) | Windows CMD script for restricted environments (with image selection) |
| [`QUICK_START.txt`](QUICK_START.txt) | Quick reference guide for corporate users |
| [`INSTALL_GUIDE_NO_ADMIN.md`](INSTALL_GUIDE_NO_ADMIN.md) | Detailed guide for no-admin environments |
| [`start_here.html`](start_here.html) | User-friendly HTML guide with clickable links |
| [`run_test_case.sh`](run_test_case.sh) | Script to create and run a simple `icoFoam` test case |
| [`GETTING_STARTED.md`](GETTING_STARTED.md) | Step-by-step guide for standard installation |
| [`UNINSTALL.md`](UNINSTALL.md) | Guide to removing OpenFOAM and Docker |
| [`Dockerfile`](Dockerfile) | Optional: Custom Dockerfile to extend the OpenFOAM image |

---

## **\ud83e\uddea Test the Installation**

Once the OpenFOAM container is running, you can test it by running:
```bash
/run_test_case.sh
```
This will:
1. Create a simple 2D pipe flow case.
2. Run `blockMesh` to generate the mesh.
3. Run `icoFoam` to simulate the flow.
4. Output results to `/home/openfoam/cases/test_icoFoam`.

Alternatively, use the built-in tutorials:
```bash
cd /home/openfoam/cases
cp -r /opt/openfoam/tutorials/incompressible/icoFoam/cavity .
cd cavity
blockMesh
icoFoam
```

---

## **\ud83d\udcca Visualize Results**

### **Inside the Container (if using openfoam/openfoam:v2412)**
```bash
paraFoam
```
- Open the case directory (e.g., `cavity` or `test_icoFoam`)
- Select the `.foam` file and click **Apply**
- Visualize velocity (`U`) or pressure (`p`)

### **On Your Host Machine (Recommended)**
Since `opencfd/openfoam-default` doesn't include ParaView:

1. **Download ParaView**: [https://www.paraview.org/download/](https://www.paraview.org/download/)
2. **Install ParaView** on your machine
3. **Open ParaView**
4. **Load your case**:
   - Navigate to `Documents\OpenFOAM_cases\cavity` (Windows)
   - Or `~/Documents/OpenFOAM_cases/cavity` (macOS/Linux)
   - Select the `.foam` file and click **Apply**
5. **Visualize the results**:
   - Use the **Pipeline Browser** to add filters (e.g., **Slice**, **Stream Tracer**)
   - Color the mesh by **U** (velocity) or **p** (pressure)

---

## **\ud83d\uded1 Uninstall OpenFOAM**

To remove OpenFOAM and Docker, follow the steps in [`UNINSTALL.md`](UNINSTALL.md).

---

## **\ud83d\udcda Documentation**

- **[Getting Started Guide](GETTING_STARTED.md)**: Detailed instructions for standard installation
- **[No-Admin Installation Guide](INSTALL_GUIDE_NO_ADMIN.md)**: For corporate environments with restrictions
- **[Quick Start Reference](QUICK_START.txt)**: Quick commands and troubleshooting
- **[Uninstall Guide](UNINSTALL.md)**: Steps to remove OpenFOAM and Docker

---

## **\ud83d\udd27 Customization**

### **Build a Custom Docker Image**
If you need additional tools (e.g., Python packages), you can build a custom image using the provided `Dockerfile`:
```bash
docker build -t my-openfoam .
docker run -it --rm -v "$HOME/OpenFOAM_cases:/home/openfoam/cases" my-openfoam
```

### **Mount Additional Directories**
To mount additional directories from your host machine:
```bash
docker run -it --rm -v "$HOME/my_cases:/home/openfoam/my_cases" opencfd/openfoam-default
```

---

## **\u2753 Troubleshooting**

### **Docker Not Running**
- **Windows/macOS**: Start Docker Desktop.
- **Linux**: Run `sudo systemctl start docker`.

### **Permission Issues**
- Add your user to the Docker group:
  ```bash
  sudo usermod -aG docker $USER
  ```
  Then log out and log back in.

### **OpenFOAM Command Not Found**
- Ensure you are inside the Docker container. Run:
  ```bash
  docker exec -it my-openfoam bash
  ```

### **Corporate Environment Issues**
- **Proxy settings**: Configure in Docker Desktop \u276f Settings \u276f Resources \u276f Proxies
- **Firewall**: Ask IT to allow connections to:
  - `hub.docker.com` (port 443)
  - `ghcr.io` (port 443)
- **Antivirus**: Ask IT to add exceptions for Docker

---

## **\ud83c\udf89 Next Steps**

1. **Explore tutorials**: Check out the cases in `/opt/openfoam/tutorials`.
2. **Modify cases**: Edit boundary conditions, mesh, or solver settings.
3. **Create your own cases**: Start from scratch or copy a tutorial case.
4. **Automate workflows**: Use Python scripts for pre- and post-processing.

---

## **\ud83d\udcde Support**

- [OpenFOAM Official Documentation](https://www.openfoam.com/documentation/)
- [OpenFOAM Docker Images (OpenCFD)](https://hub.docker.com/u/opencfd)
- [OpenFOAM Docker Images (Foundation)](https://hub.docker.com/u/openfoam)
- [OpenFOAM Discourse Forum](https://discourse.openfoam.com/)

---

## **\ud83d\udcdd License**

This project is provided as-is for educational purposes. OpenFOAM is licensed under the **GPL v3**. Docker images are provided by OpenCFD Ltd and the OpenFOAM Foundation.

---

## **\ud83d\ude4f Acknowledgments**

- [OpenFOAM](https://www.openfoam.com/)
- [OpenCFD Ltd](https://www.openfoam.com/)
- [Docker](https://www.docker.com/)
- [ParaView](https://www.paraview.org/)
