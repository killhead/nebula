#!/bin/bash

# Health check script for NebulaGraph
# This script checks if NebulaGraph is running and responding

set -e

# Default values
HOST=${NEBULA_HOST:-localhost}
PORT=${NEBULA_WS_HTTP_PORT:-19669}
TIMEOUT=${HEALTHCHECK_TIMEOUT:-10}

echo "Checking NebulaGraph health at $HOST:$PORT..."

# Check if the HTTP interface is responding
if curl -f -s --max-time $TIMEOUT "http://$HOST:$PORT/status" > /dev/null; then
    echo "NebulaGraph is healthy"
    exit 0
else
    echo "NebulaGraph health check failed"
    exit 1
fi
