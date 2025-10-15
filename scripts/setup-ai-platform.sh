#!/bin/bash
set -e

echo "🚀 Setting up AI Platform Environment..."

# Run all setup scripts in sequence
./scripts/01-cleanup.sh
./scripts/02-clone-repo.sh
./scripts/03-install-deps.sh
./scripts/04-setup-workspace.sh

echo "✅ AI Platform setup complete!"
echo "🎯 Your studio is ready at: /home/jovyan/workspace/studio"
echo "💻 Run './scripts/start-dev.sh' to begin development"