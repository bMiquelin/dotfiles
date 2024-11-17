Copy xorg.conf
`sudo cp /etc/X11/xorg.conf.new /root/xorg.conf`

Move videos
`find /mnt/sda3/p -type f -name "*.mp4" -exec cp {} ~/p \;\`

Find empty folders at ~/
`find . -type d -empty | rg "^\.\/\w"`