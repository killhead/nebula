#!/bin/bash

# NebulaGraph Startup Script for Railway
# This script initializes and starts all NebulaGraph services

set -e

echo "Starting NebulaGraph on Railway..."

# Create necessary directories
mkdir -p /data /logs
chmod 755 /data /logs

# Check if configuration files exist
for conf in nebula.conf metad.conf storaged.conf graphd.conf; do
    if [ ! -f "/usr/local/nebula/etc/$conf" ]; then
        echo "Error: $conf not found!"
        exit 1
    fi
done

# Function to start service in background
start_service() {
    local service_name=$1
    local binary_path=$2
    local config_file=$3
    
    echo "Starting $service_name..."
    $binary_path --flagfile=$config_file &
    local pid=$!
    echo "$service_name started with PID $pid"
    echo $pid > /tmp/nebula-$service_name.pid
}

# Start MetaD first
start_service "metad" "/usr/local/nebula/bin/nebula-metad" "/usr/local/nebula/etc/metad.conf"

# Wait for MetaD to be ready
echo "Waiting for MetaD to be ready..."
sleep 10

# Start StorageD
start_service "storaged" "/usr/local/nebula/bin/nebula-storaged" "/usr/local/nebula/etc/storaged.conf"

# Wait for StorageD to be ready
echo "Waiting for StorageD to be ready..."
sleep 10

# Start GraphD
start_service "graphd" "/usr/local/nebula/bin/nebula-graphd" "/usr/local/nebula/etc/graphd.conf"

# Wait for GraphD to be ready
echo "Waiting for GraphD to be ready..."
sleep 15

# Check if all services are running
echo "Checking service status..."
for service in metad storaged graphd; do
    if [ -f "/tmp/nebula-$service.pid" ]; then
        pid=$(cat /tmp/nebula-$service.pid)
        if ps -p $pid > /dev/null; then
            echo "$service is running (PID: $pid)"
        else
            echo "ERROR: $service is not running!"
            exit 1
        fi
    else
        echo "ERROR: $service PID file not found!"
        exit 1
    fi
done

echo "All NebulaGraph services started successfully!"

# Keep the container running and monitor services
while true; do
    sleep 30
    for service in metad storaged graphd; do
        if [ -f "/tmp/nebula-$service.pid" ]; then
            pid=$(cat /tmp/nebula-$service.pid)
            if ! ps -p $pid > /dev/null; then
                echo "ERROR: $service stopped unexpectedly!"
                exit 1
            fi
        fi
    done
done
