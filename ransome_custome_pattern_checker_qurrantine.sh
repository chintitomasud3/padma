#!/bin/bash
#
# ioc-watch.sh - Detect and kill known ransomware IOCs (elockcc, runscript.sh)
#

LOG_FILE="/var/log/ioc-watch.log"
QUARANTINE_DIR="/var/quarantine"
IOC_NAMES=("elockcc" "runscript.sh")
SEARCH_PATHS=("/tmp" "/var/tmp" "/dev/shm" "/home" "/opt" "/root")

mkdir -p "$QUARANTINE_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

# --- 1. Kill matching processes ---
for name in "${IOC_NAMES[@]}"; do
    pids=$(pgrep -f "$name")
    if [ -n "$pids" ]; then
        for pid in $pids; do
            kill -9 "$pid" 2>/dev/null
            log "FOUND & KILLED: $name (PID $pid)"
        done
    fi
done

# --- 2. Scan disk (quarantine dir excluded so it doesn't re-detect its own copies) ---
for path in "${SEARCH_PATHS[@]}"; do
    [ -d "$path" ] || continue
    for name in "${IOC_NAMES[@]}"; do
        find "$path" -maxdepth 5 -path "$QUARANTINE_DIR" -prune -o -type f -iname "*${name}*" -print 2>/dev/null | while read -r f; do
            cp "$f" "$QUARANTINE_DIR/" 2>/dev/null
            rm -f "$f"
            log "FOUND & REMOVED: $f"
        done
    done
done

exit 0
