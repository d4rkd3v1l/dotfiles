local settings = require("settings")

local icons = {
  sf_symbols = {
    loading = "􀖇",
    apple = "􀣺",
    clipboard = "􀉄",
    spaces = "􀏧",
    calendar = "􀉉",
    headphones = "􀑈",
    volume = {
      _100="􀊩",
      _66="􀊧",
      _33="􀊥",
      _10="􀊡",
      _0="􀊣",
    },
    battery = {
      _100 = "􀛨",
      _75 = "􀺸",
      _50 = "􀺶",
      _25 = "􀛩",
      _0 = "􀛪",
      charging = "􀢋"
    },
    wifi = {
      connected = "􀙇",
      disconnected = "􀙈",
    },
    bluetooth = {
      connected = "Missing Icon",
      disconnected = "Missing Icon",
    },
    media = {
      back = "􀊊",
      forward = "􀊌",
      play_pause = "􀊈",
    },
  },

  -- Alternative NerdFont icons
  nerdfont = {
    loading = "",
    apple = "",
    clipboard = "Missing Icon",
    spaces = "",
    calendar = "",
    headphones = "",
    volume = {
      _100="",
      _66="",
      _33="",
      _10="",
      _0="",
    },
    battery = {
      _100 = "",
      _75 = "",
      _50 = "",
      _25 = "",
      _0 = "",
      charging = ""
    },
    wifi = {
      connected = "󰖩",
      disconnected = "󰖪",
    },
    bluetooth = {
      connected = "󰂯",
      disconnected = "󰂲",
    },
    media = {
      back = "",
      forward = "",
      play_pause = "",
    },
  },
}

if not (settings.icons == "NerdFont") then
  return icons.sf_symbols
else
  return icons.nerdfont
end
