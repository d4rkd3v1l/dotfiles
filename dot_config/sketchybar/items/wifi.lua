local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local accent_color = colors.purple
local popup_width = 250

local wifi_item = sbar.add("item", "wifi", {
  position = "right",
  label = {
    color = accent_color,
    max_chars = 10,
  },
})

local wifi_bracket = sbar.add("bracket", "wifi.bracket", { wifi_item.name }, {
  background = {
    color = colors.bg1,
    border_color = accent_color,
  },
  popup = {
    align = "center",
    height = 30,
  },
})

local hostname_item = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Hostname:",
    width = popup_width / 2,
  },
  label = {
    max_chars = 20,
    string = "????????????",
    width = popup_width / 2,
    align = "right",
  }
})

local ip_item = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "IP:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  }
})

local mask_item = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Subnet mask:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  }
})

local router_item = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Router:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  },
})

sbar.add("item", {
  position = "right",
  width = settings.group_paddings,
})

wifi_item:subscribe({"wifi_change", "system_woke"}, function()
  sbar.exec("networksetup -listpreferredwirelessnetworks en0 | sed -n '2s/^\t//p'", function(ssid)
    wifi_item:set({
      label = ssid
    })
  end)

  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    wifi_item:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and accent_color or colors.comment,
      },
      label = {
        drawing = connected,
      },
    })

    wifi_bracket:set({
      background = {
        border_color = connected and accent_color or colors.comment,
      },
    })
  end)
end)

local function hide_details()
  wifi_bracket:set({
    popup = {
      drawing = false,
    },
  })
end

local function toggle_details()
  local should_draw = wifi_bracket:query().popup.drawing == "off"
  if should_draw then
    wifi_bracket:set({ popup = { drawing = true }})
    sbar.exec("networksetup -getcomputername", function(result)
      hostname_item:set({ label = result })
    end)
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip_item:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
      mask_item:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router_item:set({ label = result })
    end)
  else
    hide_details()
  end
end

wifi_item:subscribe("mouse.clicked", toggle_details)
wifi_item:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  local label = sbar.query(env.NAME).label.value
  sbar.exec("echo \"" .. label .. "\" | pbcopy")
  sbar.set(env.NAME, { label = { string = icons.clipboard, align="center" } })
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

hostname_item:subscribe("mouse.clicked", copy_label_to_clipboard)
ip_item:subscribe("mouse.clicked", copy_label_to_clipboard)
mask_item:subscribe("mouse.clicked", copy_label_to_clipboard)
router_item:subscribe("mouse.clicked", copy_label_to_clipboard)
