#!/bin/bash

echo "=== Jenkins Performance Optimization Script ==="
echo ""

# Check current system resources
echo "1. Checking current system resources..."
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'

echo ""
echo "Memory Usage:"
free -h

echo ""
echo "Disk Usage:"
df -h /

echo ""
echo "=== Step 1: Cleaning up disk space ==="
# Clean APT cache
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove -y

# Clean old logs
sudo journalctl --vacuum-time=3d
sudo find /var/log -type f -name "*.log" -mtime +7 -delete 2>/dev/null || true
sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null || true

# Clean Docker
docker container prune -f
docker image prune -a -f
docker volume prune -f
docker network prune -f

# Clean Jenkins workspace
sudo find /var/lib/jenkins/workspace -type d -mtime +7 -exec rm -rf {} + 2>/dev/null || true

echo ""
echo "=== Step 2: Optimizing Jenkins JVM settings ==="

# Backup original Jenkins config
sudo cp /etc/default/jenkins /etc/default/jenkins.backup

# Set optimal JVM settings for t3.medium (4GB RAM)
sudo tee /etc/default/jenkins > /dev/null <<EOF
# Jenkins configuration

# Port Jenkins listens on
HTTP_PORT=8080

# Java options for Jenkins
JAVA_ARGS="-Djava.awt.headless=true"

# JVM options - Optimized for t3.medium (4GB RAM)
JENKINS_JAVA_OPTIONS="-Xms512m -Xmx2048m -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+UseStringDeduplication -Djava.awt.headless=true -Dhudson.model.DirectoryBrowserSupport.CSP=\"default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';\""

# User Jenkins runs as
JENKINS_USER=jenkins

# Jenkins home directory
JENKINS_HOME=/var/lib/jenkins
EOF

echo ""
echo "=== Step 3: Disabling unnecessary Jenkins features ==="

# Create or update Jenkins system config
sudo mkdir -p /var/lib/jenkins/init.groovy.d/

# Disable usage statistics
sudo tee /var/lib/jenkins/init.groovy.d/disable-usage-stats.groovy > /dev/null <<'EOF'
import jenkins.model.Jenkins
import hudson.model.UsageStatistics

def instance = Jenkins.getInstance()
instance.setNoUsageStatistics(true)
instance.save()
EOF

# Set number of executors to 2 (optimal for t3.medium)
sudo tee /var/lib/jenkins/init.groovy.d/set-executors.groovy > /dev/null <<'EOF'
import jenkins.model.Jenkins

def instance = Jenkins.getInstance()
instance.setNumExecutors(2)
instance.save()
EOF

echo ""
echo "=== Step 4: Cleaning Jenkins old builds ==="

# Clean old builds (keep only last 5)
sudo find /var/lib/jenkins/jobs/*/builds/* -maxdepth 0 -type d | sort -r | tail -n +6 | xargs rm -rf 2>/dev/null || true

echo ""
echo "=== Step 5: Restarting Jenkins ==="
sudo systemctl restart jenkins

echo ""
echo "Waiting for Jenkins to start (30 seconds)..."
sleep 30

echo ""
echo "=== Step 6: Checking Jenkins status ==="
sudo systemctl status jenkins --no-pager

echo ""
echo "=== Optimization Complete! ==="
echo ""
echo "Current system resources after optimization:"
echo "Memory Usage:"
free -h
echo ""
echo "Disk Usage:"
df -h /
echo ""
echo "Jenkins should now be faster!"
echo "Access Jenkins at: http://$(curl -s ifconfig.me):8080"
echo ""
echo "If still slow, consider:"
echo "1. Upgrading to t3.large (8GB RAM)"
echo "2. Increasing EBS volume size"
echo "3. Disabling unused plugins"

# Made with Bob
