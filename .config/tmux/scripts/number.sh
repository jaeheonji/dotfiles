#!/bin/bash

# icons=(󰎢 󰎥 󰎨 󰎫 󰎲 󰎯 󰎴 󰎷 󰎺 󰎽)
icons=(󰎦 󰎩 󰎬 󰎮 󰎰 󰎵 󰎸 󰎻 󰎾)

if [[ -z "$1" || "$1" -lt 0 || "$1" -gt 9 ]] 2>/dev/null; then
  exit 1
fi

echo -n " ${icons[$1-1]} "
