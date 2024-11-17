#!/bin/bash

echo "Updating GRUB configuration..."
cat /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB configuration updated successfully."