# OpenFOAM Docker Agent

A simple agent to install and run **OpenFOAM** on any machine using **Docker**. This project provides scripts to:
- Install Docker (if not already installed).
- Run OpenFOAM in a Docker container.
- Test the installation with a simple `icoFoam` case.
- Visualize results in ParaView.

---

## **📌 Features**

✅ **Cross-platform**: Works on **Windows, macOS, and Linux**.
✅ **Minimal setup**: Only requires Docker.
✅ **Latest OpenFOAM**: Uses **OpenFOAM v2412** (latest stable release).
✅ **ParaView included**: Visualize results directly in the container.
✅ **Python support**: Optional Python tools for post-processing.
✅ **Test case**: Verify installation with a simple `icoFoam` simulation.
✅ **Uninstall guide**: Easy cleanup of Docker containers and images.

---

## **🚀 Quick Start**

### **1. Clone or Download This Repository**
```bash
git clone https://github.com/Brixpowers90/OpenFoamGetStarted.git
cd OpenFoamGetStarted
```

### **2. Run the Installation Script**

#### **Windows (PowerShell)**
```powershell
.\install_openfoam_docker.ps1
```

#### **macOS/Linux (Bash)**
```bash
chmod +x install_openfoam_docker.sh
./install_openfoam_docker.sh
```

### **3. Follow the Prompts**
- The script will check if Docker is installed.
- If not, it will guide you to install Docker.
- Once Docker is running, it will download the OpenFOAM image and start a container.
- You will be prompted to run a test case (`icoFoam`).

---

## **📂 Project Structure**

| File | Description |
|------|-------------|
| [`install_openfoam_docker.ps1`](install_openfoam_docker.ps1) | Windows PowerShell script to install and run OpenFOAM in Docker. |
| [`install_openfoam_docker.sh`](install_openfoam_docker.sh) | macOS/Linux Bash script to install and run OpenFOAM in Docker. |
| [`run_test_case.sh`](run_test_case.sh) | Script to create and run a simple `icoFoam` test case inside the container. |
| [`GETTING_STARTED.md`](GETTING_STARTED.md) | Step-by-step guide to using OpenFOAM with Docker. |
| [`UNINSTALL.md`](UNINSTALL.md) | Guide to removing OpenFOAM and Docker. |
| [`Dockerfile`](Dockerfile) | Optional: Custom Dockerfile to extend the OpenFOAM image. |

---

## **🧪 Test the Installation**

Once the OpenFOAM container is running, you can test it by running:
```bash
/run_test_case.sh
```
This will:
1. Create a simple 2D pipe flow case.
2. Run `blockMesh` to generate the mesh.
3. Run `icoFoam` to simulate the flow.
4. Output results to `/home/openfoam/cases/test_icoFoam`.

---

## **📊 Visualize Results**

### **Inside the Container**
```bash
paraFoam
```
- Open the `test_icoFoam` case in ParaView.
- Visualize velocity (`U`) or pressure (`p`).

### **On Your Host Machine**
- Results are saved in:
  - Windows: `%USERPROFILE%\OpenFOAM_cases\test_icoFoam`
  - macOS/Linux: `~/OpenFOAM_cases/test_icoFoam`
- Open ParaView on your host and load the case directory.

---

## **🛑 Uninstall OpenFOAM**

To remove OpenFOAM and Docker, follow the steps in [`UNINSTALL.md`](UNINSTALL.md).

---

## **📚 Documentation**

- **[Getting Started Guide](GETTING_STARTED.md)**: Detailed instructions for running your first simulation.
- **[Uninstall Guide](UNINSTALL.md)**: Steps to remove OpenFOAM and Docker.

---

## **🔧 Customization**

### **Build a Custom Docker Image**
If you need additional tools (e.g., Python packages), you can build a custom image using the provided `Dockerfile`:
```bash
docker build -t my-openfoam .
docker run -it --rm -v "$HOME/OpenFOAM_cases:/home/openfoam/cases" my-openfoam
```

### **Mount Additional Directories**
To mount additional directories from your host machine:
```bash
docker run -it --rm -v "$HOME/my_cases:/home/openfoam/my_cases" openfoam/openfoam:v2412
```

---

## **❓ Troubleshooting**

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
  docker exec -it openfoam-v2412 bash
  ```

---

## **🎉 Next Steps**

1. **Explore tutorials**: Check out the cases in `/opt/openfoam/tutorials`.
2. **Modify cases**: Edit boundary conditions, mesh, or solver settings.
3. **Create your own cases**: Start from scratch or copy a tutorial case.
4. **Automate workflows**: Use Python scripts for pre- and post-processing.

---

## **📞 Support**

- [OpenFOAM Official Documentation](https://www.openfoam.com/documentation/)
- [OpenFOAM Docker GitHub](https://github.com/OpenFOAM/OpenFOAM-docker)
- [OpenFOAM Discourse Forum](https://discourse.openfoam.com/)

---

## **📝 License**

This project is provided as-is for educational purposes. OpenFOAM is licensed under the **GPL v3**. Docker images are provided by [OpenCFD Ltd](https://www.openfoam.com/).

---

## **🙏 Acknowledgments**

- [OpenFOAM](https://www.openfoam.com/)
- [Docker](https://www.docker.com/)
- [ParaView](https://www.paraview.org/)
