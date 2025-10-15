#!/bin/bash
echo "🧹 Cleaning system..."
sudo rm -rf /tmp/* /var/tmp/* /home/jovyan/.cache/* 2>/dev/null || true
find /home/jovyan -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
echo "✅ Cleanup done"