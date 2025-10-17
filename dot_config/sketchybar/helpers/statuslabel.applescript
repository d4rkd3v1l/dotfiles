#!/usr/bin/osascript
on run argv
  set appName to item 1 of argv
  tell application "System Events"
    tell process "Dock"
      try
        set statusLabel to value of attribute "AXStatusLabel" of UI element appName of list 1
        if statusLabel is missing value then # "missing value" when e.g. no badge visible
          return 0
        else
          return statusLabel
        end if
      on error # e.g. when app not found
        return -1
      end try
    end tell
  end tell
end run
