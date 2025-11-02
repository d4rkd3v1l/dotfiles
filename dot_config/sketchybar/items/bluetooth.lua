local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local accent_color = colors.blue

local bluetooth_item = sbar.add("item", "bluetooth", {
  position = "right",
  label = {
    color = accent_color,
    max_chars = 10,
  },
})

local bluetooth_bracket = sbar.add("bracket", "bluetooth.bracket", {
  bluetooth_item.name,
}, {
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

bluetooth_item:subscribe({"wifi_change", "system_woke"}, function()
  sbar.exec("networksetup -listpreferredwirelessnetworks en0 | sed -n '2s/^\t//p'", function(ssid)
    bluetooth_item:set({
      label = ssid
    })
  end)

  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    bluetooth_item:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and accent_color or colors.comment,
      },
      label = {
        drawing = connected,
      },
    })

    bluetooth_bracket:set({
      background = {
        border_color = connected and accent_color or colors.comment,
      },
    })
  end)
end)
