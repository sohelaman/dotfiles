# Fedora 44

## NVIDIA Drivers for Pascal GPU
```bash
dnf install akmod-nvidia-580xx xorg-x11-drv-nvidia-580xx xorg-x11-drv-nvidia-580xx-cuda
dracut --force
```
## IMPORTANT! Wait for akmods Compilation to Finish
Check CPU usages or check `journalctl -f | grep akmods`

## Post Installation
```bash
modinfo -F version nvidia  ## should return driver version
nvidia-smi
```

## Container Toolkit
```bash
dnf install -y libnvidia-container-tools nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker
systemctl restart docker

## Test
docker run --gpus all --rm nvidia/cuda:12.9.2-base-ubuntu24.04 nvidia-smi
```
