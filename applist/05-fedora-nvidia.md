# NVIDIA Drivers for Pascal GPU
```bash
dnf install akmod-nvidia-580xx xorg-x11-drv-nvidia-580xx xorg-x11-drv-nvidia-580xx-cuda
dracut --force
```
# IMPORTANT! Wait for akmods Compilation to Finish
Check CPU usages or check `journalctl -f | grep akmods`

# Post Installation
```
modinfo -F version nvidia  ## should return driver version
```
