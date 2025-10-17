local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

local workspaces = get_workspaces()
local current_workspace = get_current_workspace()
local function split(str, sep)
  local result = {}
  local regex = ("([^%s]+)"):format(sep)
  for each in str:gmatch(regex) do
    table.insert(result, each)
  end
  return result
end

local function updateSpace(index)
  sbar.exec("aerospace list-windows --workspace " .. index .. " --format '%{app-name}' --json ", function(apps)
    local icon_line = ""
    local no_app = true
    for i, app in ipairs(apps) do
      no_app = false
      local app_name = app["app-name"]
      local lookup = app_icons[app_name]
      local icon = ((lookup == nil) and app_icons["default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    if no_app then
      icon_line = " —"
    end

    sbar.animate("tanh", 10, function()
      spaces[index]:set({
        label = icon_line
      })
    end)
  end)
end

for i, workspace in ipairs(workspaces) do
  local selected = workspace == current_workspace
  local space = sbar.add("item", "space." .. i, {
    icon = {
      font = {
        family = settings.font.numbers
      },
      string = i,
      padding_left = 8,
      padding_right = 6,
      color = colors.white,
      highlight_color = colors.workspace_colors[i],
      highlight = selected
    },
    label = {
      padding_right = 16,
      color = colors.white,
      highlight_color = colors.workspace_colors[i],
      font = settings.icons,
      y_offset = -1,
      highlight = selected
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_color = selected and colors.workspace_colors[i] or colors.bg2
    },
    popup = {
      background = {
        border_width = 5,
        border_color = colors.black
      }
    }
  })

  spaces[i] = space
  -- Define the icons for open apps on each space initially
  updateSpace(i)

  -- Padding space between each item
  sbar.add("item", "item." .. i .. ".padding", {
    script = "",
    width = 5,
  })

  -- Item popup
  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("aerospace_workspace_change", function(env)
    local selected = env.FOCUSED_WORKSPACE == workspace
    space:set({
      icon = {
        highlight = selected
      },
      label = {
        highlight = selected
      },
      background = {
        border_color = selected and colors.workspace_colors[i] or colors.bg2
      }
    })

  end)

  space:subscribe("mouse.clicked", function(env)
    local SID = split(env.NAME, ".")[2]
    if env.BUTTON == "other" then
      space_popup:set({
        background = {
          image = "item." .. SID
        }
      })
      space:set({
        popup = {
          drawing = "toggle"
        }
      })
    else
      sbar.exec("aerospace workspace " .. SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({
      popup = {
        drawing = false
      }
    })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true
})

-- Handles the small icon indicator for spaces / menus changes
local spaces_indicator = sbar.add("item", "spaces", {
  drawing = false,
  padding_right = 1,
  padding_left = -20, -- no clue why this is needed
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.white,
    string = icons.spaces
  },
  label = {
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.white
  },
  background = {
    color = colors.bg1,
    -- border_color = colors.comment,
  }
})

-- Event handles
space_window_observer:subscribe("space_windows_change", function(env)
  for i, workspace in ipairs(workspaces) do
    updateSpace(i)
  end
end)

space_window_observer:subscribe("aerospace_focus_change", function(env)
  for i, workspace in ipairs(workspaces) do
    updateSpace(i)
  end
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
