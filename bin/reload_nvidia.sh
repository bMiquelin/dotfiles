#!/bin/bash

sudo mkinitcpio -P

echo "lsmod | grep nvidia"
sudo lsmod | grep nvidia

echo "dmesg | grep -i nvidia"
sudo dmesg | grep -i nvidia

echo "nvidia-smi"
nvidia-smi