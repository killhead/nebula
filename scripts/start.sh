#!/bin/bash

# NebulaGraph Startup Script for Railway
# This script initializes and starts NebulaGraph services

set -e

echo "Starting NebulaGraph on Railway..."

# Create necessary directories
mkdir -p /data /logs

# Set permissions
chmod 755 /data /logs

# Check if configuration files exist
if [ ! -f "/usr/local/nebula/etc/graphd.conf" ]; then
    echo "Error: graphd.conf not found!"
    exit 1
fi

# Start NebulaGraph GraphD
echo "Starting NebulaGraph GraphD service..."
exec /usr/local/nebula/bin/nebula-graphd --flagfile=/usr/local/nebula/etc/graphd.conf
