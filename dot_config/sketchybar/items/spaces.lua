local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local appIcons = require("helpers.app_icons")

local spaces = {}
local maxAppsPerSpace = 4

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

local function updateSpaces()
  for spaceIndex, workspace in ipairs(workspaces) do

    sbar.exec("aerospace list-windows --workspace " .. spaceIndex .. " --format '%{app-name}' --json ", function(apps)
      local selected = current_workspace == workspace
      local no_app = true

      -- Update space indicator
      sbar.set("space." .. spaceIndex .. ".app.0", {
        label = {
          highlight = selected,
        },
      })

      -- Update space (bracket) border
      sbar.set("space." .. spaceIndex, {
        background = {
          border_color = selected and colors.workspace_colors[spaceIndex] or colors.bg2
        }
      })

      -- Update apps (windows)
      sbar.animate("tanh", 10, function()
        for appIndex = 0, maxAppsPerSpace, 1 do
          local app = apps[appIndex]
          if app ~= nil then
            local appName = app["app-name"]
            local lookup = appIcons[appName]
            local icon = ((lookup == nil) and appIcons["default"] or lookup)

            sbar.set("space." .. spaceIndex .. ".app." .. appIndex, {
              drawing = true,
              icon = {
                drawing = true,
                string = icon,
                -- color = (appName == "Signal") and colors.pink or colors.white,
                highlight = selected,
              },
              label = {
                drawing = false,
                highlight = selected,
              },
              background = {
                -- color = (appName == "Signal") and colors.pink or colors.transparent,
              }
            })
          else
            sbar.set("space." .. spaceIndex .. ".app." .. appIndex, {
              drawing = (appIndex == 0) and true or false
            })
          end
        end

        -- Handle empty spaces
        if next(apps) == nil then
            sbar.set("space." .. spaceIndex .. ".app.1", {
              drawing = true,
              icon = {
                drawing = false,
              },
              label = {
                drawing = true,
                string = "—",
                highlight = selected,
              },
            })
        end
      end)
    end)
  end
end

for spaceIndex, workspace in ipairs(workspaces) do
  local apps = {}
  for appIndex = 0, maxAppsPerSpace, 1 do
    local app = sbar.add("item", "space." .. spaceIndex .. ".app." .. appIndex, {
      drawing = (appIndex == 0) and true or false,
      icon = {
        drawing = false,
        font = settings.icons,
        padding_left = 5,
        padding_right = 5,
        color = colors.white,
        highlight_color = colors.workspace_colors[spaceIndex],
        highlight = selected
      },
      label = {
        drawing = (appIndex == 0) and true or false,
        padding_left = 10,
        padding_right = 6,
        color = colors.white,
        font = {
          family = settings.font.numbers,
          size = 14.0,
        },
        highlight_color = colors.workspace_colors[spaceIndex],
        highlight = selected,
        string = spaceIndex,
      },
      padding_left = 2,
      padding_right = 2,
      background = {
        height = 24,
        corner_radius = 8,
        color = colors.transparent,
        border_color = colors.transparent
      },
    })

    app:subscribe("mouse.clicked", function(env)
      local SID = split(env.NAME, ".")[2]
      sbar.exec("aerospace workspace --fail-if-noop " .. SID)
    end)

    apps[appIndex] = app.name
  end

  local space = sbar.add("bracket", "space." .. spaceIndex, apps, {
    background = {
      color = colors.bg1
    }
  })

  spaces[spaceIndex] = space

  sbar.add("item", "space." .. spaceIndex .. ".padding", {
    script = "",
    width = 5,
  })

  updateSpaces()
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true
})

-- Handles the small icon indicator for spaces / menus changes
local spaces_indicator = sbar.add("item", "spaces", {
  drawing = false,
  padding_left = settings.group_paddings,
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
})

-- Event handles
space_window_observer:subscribe("aerospace_workspace_change", function(env)
  current_workspace = env.FOCUSED_WORKSPACE
  updateSpaces()
end)

space_window_observer:subscribe("aerospace_focus_change", function(env)
  updateSpaces()
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
