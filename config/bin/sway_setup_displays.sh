#!/bin/bash


# Checks if the monitor is available and disables the laptop monitor if so.
# This script is used in the sway configuration file


# Check if DP-3 exists in the list of connected outputs
if swaymsg -t get_outputs | grep -q 'DP-3'; then
  echo "DP-3 found, not changing outputs."
  swaymsg  output eDP-1 disable
  swaymsg  output DP-3 enable
else 
  # If DP-3 is not found, enable eDP-1
  echo "DP-3 not found, enabling eDP-1."
  swaymsg output eDP-1 enable
fi
