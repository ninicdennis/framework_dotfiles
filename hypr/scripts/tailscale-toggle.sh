#!/usr/bin/env bash

# Check if tailscale is installed
if ! command -v tailscale &> /dev/null; then
    notify-send "Tailscale" "Tailscale is not installed" -u critical
    exit 1
fi

# Get current state
STATE=$(tailscale status --json 2>/dev/null | jq -r '.BackendState')

if [ "$STATE" = "Running" ]; then
    # Tailscale is running, turn it off
    notify-send "Tailscale" "Disconnecting..." -u normal
    if tailscale down; then
        notify-send "Tailscale" "Disconnected" -u normal
    else
        notify-send "Tailscale" "Failed to disconnect" -u critical
    fi
else
    # Tailscale is not running, turn it on
    notify-send "Tailscale" "Connecting..." -u normal
    if tailscale up; then
        notify-send "Tailscale" "Connected" -u normal
    else
        notify-send "Tailscale" "Failed to connect" -u critical
    fi
fi
