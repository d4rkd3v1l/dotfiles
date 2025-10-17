local settings = require("settings")
local icons = require("icons")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local time = sbar.add("item", "time", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = { drawing = false },
  label = {
    font = {
      -- family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
  },
  y_offset = -6,
  click_script = "open -a 'Calendar'",
})

local date = sbar.add("item", "date", {
  position = "right",
  padding_left = -5,
  icon = { drawing = false },
  label = {
    font = {
      -- family = settings.font.numbers,
      style = settings.font.style_map["Heavy"],
      size = 10.0,
    },
  },
  y_offset = 6,
  click_script = "open -a 'Calendar'",
})

local cal = sbar.add("item", "cal", {
  position = "right",
  icon = {
    string = icons.calendar,
  },
  label = { drawing = false },
  update_freq = 1,
  click_script = "open -a 'Calendar'",
})

-- Background around the item
local cal_bracket = sbar.add("bracket", "cal.bracket", {
  cal.name,
  date.name,
  time.name
}, {
  background = { color = colors.bg1 },
  popup = { align = "center", height = 30 }
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  date:set({ label = os.date("%a %d. %b") })
  time:set({ label = os.date("%H:%M:%S") })
end)
