# Copy xorg.conf
`sudo cp /etc/X11/xorg.conf.new /root/xorg.conf`

# Move videos
`find /mnt/sda3/p -type f -name "*.mp4" -exec cp {} ~/p \;\`

# Find empty folders at ~/
`find . -type d -empty | rg "^\.\/\w"`

# Autologin systemd->agetty
sudo systemctl disable lightdm.service
sudo systemctl set-default multi-user.target
sudo systemctl daemon-reload
sudo systemctl edit getty@tty1.service
```service
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin your_username --noclear %I $TERM
```
`sudo systemctl daemon-reload`
.bash_profile/.zprofile
```bash
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi
```
# DM
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service
sudo systemctl daemon-reload
