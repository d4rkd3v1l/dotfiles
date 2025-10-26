local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = {
    font = settings.icons,
    string = app_icons["Default"]
  },
  updates = true,
})

sbar.add("bracket", "front_app.bracket", { front_app.name }, {
  background = {
    color = colors.bg1,
    border_color = colors.comment
  }
})

front_app:subscribe("front_app_switched", function(env)
  local lookup = app_icons[env.INFO]
  local icon = ((lookup == nil) and app_icons["default"] or lookup)
  front_app:set({ icon = icon, label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
