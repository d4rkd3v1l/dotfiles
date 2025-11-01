local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local accent_color = colors.green

-- Toggle between "percentage" and "remaining"
local show_percentage = true

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Regular"],
      size = 19.0,
    },
  },
  label = {
    color = accent_color,
  },
  update_freq = 60,
  popup = { align = "center" },
})

local bracket = sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = { 
    color = colors.bg1,
  }
})

sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.group_paddings,
})

local function update() 
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found_charge, _, charge = batt_info:find("(%d+)%%")
    if found_charge then
      charge = tonumber(charge)
    end

    local color = accent_color
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = icons.battery.charging
    else
      if found_charge and charge > 80 then
        icon = icons.battery._100
      elseif found_charge and charge > 60 then
        icon = icons.battery._75
      elseif found_charge and charge > 40 then
        icon = icons.battery._50
      elseif found_charge and charge > 20 then
        icon = icons.battery._25
        color = colors.orange
      else
        icon = icons.battery._0
        color = colors.red
      end
    end

    local lead = ""
    if found_charge and charge < 10 then
      lead = "0"
    end

    if show_percentage and found_charge then
      label = charge .. "%"
    else
      local found_remaining, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      label = found_remaining and remaining .. "h" or "No estimate"
    end

    battery:set({
      icon = {
        string = icon,
        color = color,
      },
      label = {
        string = lead .. label,
        color = color,
      },
    })

    bracket:set({
      background = {
        border_color = color,
      },
    })
  end)
end

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  update()
end)

battery:subscribe("mouse.clicked", function(env)
  show_percentage = not show_percentage
  update()
end)

