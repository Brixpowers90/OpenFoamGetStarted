# OpenFOAM Docker Uninstallation Guide

This guide explains how to remove OpenFOAM and its dependencies from your system when using Docker.

---

## **1. Stop and Remove Docker Containers**

### **List running containers**
```bash
docker ps -a
```

### **Stop the OpenFOAM container**
If the container is running:
```bash
docker stop openfoam-v2412
```

### **Remove the container**
```bash
docker rm openfoam-v2412
```

---

## **2. Remove Docker Images**

### **List Docker images**
```bash
docker images
```

### **Remove the OpenFOAM image**
```bash
docker rmi openfoam/openfoam:v2412
```

### **Remove all unused images (optional)**
```bash
docker image prune -a
```

---

## **3. Remove Host Files**

The Docker container mounts a directory on your host machine to save OpenFOAM cases. To remove these files:

### **Windows**
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\OpenFOAM_cases"
```

### **macOS/Linux**
```bash
rm -rf ~/OpenFOAM_cases
```

---

## **4. Uninstall Docker (Optional)**

If you no longer need Docker, you can uninstall it:

### **Windows**
1. Open **Control Panel** > **Programs and Features**.
2. Find **Docker Desktop** and uninstall it.
3. Delete any remaining Docker files in `C:\Program Files\Docker`.

### **macOS**
1. Open **Finder** > **Applications**.
2. Drag **Docker Desktop** to the trash.
3. Run the following command to remove Docker files:
   ```bash
   rm -rf ~/.docker
   ```

### **Linux**
Run the following commands to uninstall Docker:
```bash
# Remove Docker packages
sudo apt-get remove --purge docker-ce docker-ce-cli containerd.io

# Remove Docker files
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove Docker user group
sudo groupdel docker

# Remove Docker configuration files
rm -rf ~/.docker
```

---

## **5. Verify Uninstallation**

### **Check Docker is removed**
```bash
docker --version
```
If Docker is uninstalled, this command should return an error.

### **Check OpenFOAM files are removed**
- Ensure the `OpenFOAM_cases` directory is deleted.
- Ensure no OpenFOAM containers or images remain (`docker ps -a` and `docker images` should be empty).

---

## **Summary**

| Step | Action | Command |
|------|--------|---------|
| 1 | Stop container | `docker stop openfoam-v2412` |
| 2 | Remove container | `docker rm openfoam-v2412` |
| 3 | Remove image | `docker rmi openfoam/openfoam:v2412` |
| 4 | Remove host files | `rm -rf ~/OpenFOAM_cases` |
| 5 | Uninstall Docker | OS-specific (see above) |

---

## **Need Help?**

If you encounter issues during uninstallation:
- **Docker not stopping?** Try `docker system prune -a --volumes` to clean up all Docker resources.
- **Permission errors?** Use `sudo` for Linux/macOS commands if needed.
- **Files not deleting?** Ensure no processes are using the files before deleting them.
