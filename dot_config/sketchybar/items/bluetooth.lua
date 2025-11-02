local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local accent_color = colors.blue
sbar.add("event", "bluetooth_change", "com.apple.bluetooth.status")

local bluetooth_item = sbar.add("item", "bluetooth", {
  position = "right",
  icon = {
    string = "󰂯",
    color = accent_color,
  },
  label = {
    drawing = false,
    color = accent_color,
    max_chars = 10,
  },
})

local bluetooth_bracket = sbar.add("bracket", "bluetooth.bracket", { bluetooth_item.name }, {
  background = {
    color = colors.bg1,
    border_color = accent_color,
  },
  popup = {
    align = "center",
    height = 30,
  },
})

sbar.add("item", {
  position = "right",
  width = settings.group_paddings,
})

bluetooth_item:subscribe({"bluetooth_change", "system_woke"}, function()
  sbar.exec([[system_profiler SPBluetoothDataType -json -detailLevel mini 2>/dev/null | jq -r '.SPBluetoothDataType[].controller_properties.controller_state' | tr -d '\n']], function(bluetooth_state)
    sbar.exec([[system_profiler SPBluetoothDataType -json -detailLevel mini 2>/dev/null | jq -r '.SPBluetoothDataType[].device_connected[] | to_entries[] | select(.value.device_minorType == "Headphones") | .key']], function(headphones_name)
      local bluetooth_on = bluetooth_state == "attrib_on"
      local headphones_connected = headphones_name ~= ""

      local bluetooth_icon
      if bluetooth_on then
        if headphones_connected then
          bluetooth_icon = icons.headphones
          else
          bluetooth_icon = "󰂯"
        end
        else
        bluetooth_icon = "󰂲"
      end

      bluetooth_item:set({
        icon = {
          string = bluetooth_icon,
          color = bluetooth_on and accent_color or colors.comment,
        },
        label = {
          drawing = bluetooth_on and headphones_connected,
          string = headphones_name,
        },
      })

      bluetooth_bracket:set({
        background = {
          border_color = bluetooth_on and accent_color or colors.comment,
        },
      })
    end)
  end)
end)
