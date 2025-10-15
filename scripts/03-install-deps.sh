#!/bin/bash
echo "📦 Installing Python dependencies..."
pip3 install --user requests pyyaml redis psycopg2-binary ollama

echo "📦 Installing Bun dependencies..."
cd /home/jovyan/workspace/studio
bun install
echo "✅ Dependencies installed"