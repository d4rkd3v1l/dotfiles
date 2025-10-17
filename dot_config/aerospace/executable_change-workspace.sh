#!/usr/bin/env bash

AEROSPACE_FOCUSED_WORKSPACE="$1"

sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"

declare -A workspace_colors

workspace_colors[1]="#BD93F9"
workspace_colors[2]="#FFB86C"
workspace_colors[3]="#8BE9FD"
workspace_colors[4]="#FF79C6"
workspace_colors[5]="#50FA7B"
workspace_colors[6]="#F1FA8C"

color="${workspace_colors[$AEROSPACE_FOCUSED_WORKSPACE]:-#FF5555}"
borders active_color=0xFF"${color#\#}"
