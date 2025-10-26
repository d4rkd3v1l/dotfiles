#!/usr/bin/env bash

APP_NAME="$1"
WINDOW_TITLE="$2"
OPEN_COMMAND="$3"

WINDOW_ID="$(aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}' \
  | awk -F'|' -v app="$APP_NAME" -v title="$WINDOW_TITLE" '$2 ~ app && $3 ~ title {if($1>max) max=$1} END{print max}')"

if [ "$WINDOW_ID" != "" ]; then
  echo "focus"
  aerospace focus --window-id "$WINDOW_ID"
else
  eval "$OPEN_COMMAND"
fi
