#!/bin/bash

# ============================================
#  SYSTEM HEALTH MONITORING SCRIPT
#  Author: Mohammed Habib Waheed
#  Purpose: Monitor system resources and services
# ============================================

source ./config.sh

echo "============================================"
echo "    SYSTEM HEALTH MONITOR"
echo "============================================"
echo ""

echo "Report Generated: $(date)"
echo "Hostname: $(hostname)"
echo ""

MODE="${MODE:-prod}"
echo "Environment: $MODE"
echo "============================================"
echo ""

# ============================================
# SYSTEM INFORMATION
# ============================================

if [ "$MODE" == "dev" ]; then
    echo "=== DEV MODE: MEMORY CHECK ==="
    echo ""
    echo "Memory Utilization:"
    free -m
    echo ""

elif [ "$MODE" == "staging" ]; then
    echo "=== STAGING MODE: DISK CHECK ==="
    echo ""
    echo "Disk Utilization:"
    df -h
    echo ""

elif [ "$MODE" == "prod" ]; then
    echo "=== PRODUCTION MODE: FULL CHECK ==="
    echo ""

    echo "System Uptime:"
    uptime
    echo ""

    echo "Memory Utilization:"
    free -m
    echo ""

    echo "Disk Utilization:"
    df -h | awk -v warn="$DISK_WARN" -v crit="$DISK_CRIT" '
    NR==1 {print; next}
    {
        usage = substr($5, 1, length($5)-1)
        if (usage >= crit) {
            print $0 "  ❌ CRITICAL"
        } else if (usage >= warn) {
            print $0 "  ⚠️ WARNING"
        } else {
            print $0 "  ✅ OK"
        }
    }'
    echo ""

else
    echo "ERROR: Invalid MODE '\''$MODE'\' '"
    echo "Valid options: dev, staging, prod"
    exit 1
fi

# ============================================
# SERVICE HEALTH CHECK
# ============================================

echo "=== SERVICE HEALTH ==="
echo ""

if systemctl is-active "$SERVICE" > /dev/null 2>&1; then
    echo "✅ $SERVICE is running"
else
    echo "❌ $SERVICE is NOT running"
fi

echo ""

# ============================================
# NETWORK CONNECTIVITY CHECK
# ============================================

echo "=== NETWORK CONNECTIVITY ==="
echo ""

echo "Checking connection to $HOST..."

if curl -s --head --max-time 6 "https://$HOST" > /dev/null 2>&1; then
    echo "✅ HTTP connection successful"
else
    echo "⚠️ HTTP connection failed"

    if ping -c 2 "$HOST" > /dev/null 2>&1; then
        echo "✅ Network reachable (but web service may be down)"
    else
        echo "❌ Network NOT reachable"
    fi
fi

echo ""
echo "============================================"
echo "    HEALTH CHECK COMPLETE"
echo "============================================"