echo "=== KEEPING SESSION ACTIVE ==="
# Start a simple counting process
while true; do echo "$(date): Session active"; sleep 30; done &
KEEP_ALIVE_PID=$!
echo "Keep-alive process started: PID $KEEP_ALIVE_PID"