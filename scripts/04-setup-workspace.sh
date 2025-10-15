#!/bin/bash
echo "⚙️ Setting up workspace..."

# Make all scripts executable
chmod +x /home/jovyan/scripts/*.sh

# Start keep-alive daemon
nohup scripts/keep-alive.sh > /tmp/keep-alive.log 2>&1 &
echo $! > /tmp/keep-alive.pid
echo "🔄 Keep-alive started (PID: $!)"


echo "🎯 Development environment ready!"
echo "Your AI platform is ready in VS Code!"
echo "Studio location: /home/jovyan/workspace/studio"
echo "Available scripts in: /home/jovyan/scripts/"
echo "✅ Workspace ready"