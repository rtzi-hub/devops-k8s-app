#!/bin/bash
set -e

echo "Starting Node.js application..."
node k8s-test.js --host 0.0.0.0 --port 8080
