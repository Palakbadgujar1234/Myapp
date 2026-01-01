#!/bin/bash

echo "=== Disk Space Cleanup Script ==="
echo ""
echo "Current disk usage:"
df -h /

echo ""
echo "=== Step 1: Cleaning APT cache ==="
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove -y

echo ""
echo "=== Step 2: Cleaning old logs ==="
sudo journalctl --vacuum-time=3d
sudo find /var/log -type f -name "*.log" -mtime +7 -delete 2>/dev/null || true
sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null || true

echo ""
echo "=== Step 3: Cleaning Docker ==="
# Remove stopped containers
docker container prune -f
# Remove unused images
docker image prune -a -f
# Remove unused volumes
docker volume prune -f
# Remove unused networks
docker network prune -f

echo ""
echo "=== Step 4: Cleaning temporary files ==="
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

echo ""
echo "=== Step 5: Cleaning old kernels (if any) ==="
sudo apt-get autoremove --purge -y

echo ""
echo "=== Final disk usage ==="
df -h /

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "If still low on space, consider:"
echo "1. Increasing EBS volume size in AWS"
echo "2. Removing unnecessary files manually"
echo "3. Moving Docker data to larger volume"

# Made with Bob
