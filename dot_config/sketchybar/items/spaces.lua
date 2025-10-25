local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local appIcons = require("helpers.app_icons")

local spaces = {}
local maxAppsPerSpace = 4
local spaceNames = {}
spaceNames["1"] = "a"
spaceNames["2"] = "s"
spaceNames["3"] = "d"
spaceNames["4"] = "f"
spaceNames["5"] = "g"
spaceNames["6"] = "y"
spaceNames["7"] = "x"
spaceNames["8"] = "c"
spaceNames["9"] = "v"
spaceNames["10"] = "b"

local workspaces = get_workspaces()
local prev_workspace = get_current_workspace()
local current_workspace = get_current_workspace()
local function split(str, sep)
  local result = {}
  local regex = ("([^%s]+)"):format(sep)
  for each in str:gmatch(regex) do
    table.insert(result, each)
  end
  return result
end

local function updateStatusLabel(app, isSelected)
  -- Need to strip LTR marker \u200E as e.g. WhatsApp uses it
  sbar.exec("osascript ./helpers/statuslabel.applescript \"" .. app.appName:gsub("\u{200E}", "") .. "\"", function(statusLabel)
    local statusLabelAsNumber = tonumber(statusLabel)
    local showStatusLabel = statusLabelAsNumber == nil or statusLabelAsNumber > 0

    app.statusLabel:set({
      drawing = showStatusLabel,
      label = {
        string = statusLabel
      }
    })
  end)
end

local function updateSpaces()
  for spaceIndex, workspace in ipairs(workspaces) do

    sbar.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' --json ", function(aerospaceApps)
      local selected = current_workspace == workspace

      -- Update space indicator
      spaces[workspace].apps[0].app:set({
        label = {
          highlight = selected,
        },
      })

      -- Update space (bracket) border
      spaces[workspace].space:set({
        background = {
          border_color = selected and colors.accent_color or colors.bg2
        }
      })

      -- Update apps (actually windows)
      sbar.animate("tanh", 10, function()
        for appIndex = 0, maxAppsPerSpace, 1 do
          local aerospaceApp = aerospaceApps[appIndex]
          local app = spaces[workspace].apps[appIndex]
          if aerospaceApp ~= nil then
            local appName = aerospaceApp["app-name"]
            local lookup = appIcons[appName]
            local icon = ((lookup == nil) and appIcons["Default"] or lookup)

            app.appName = appName
            app.app:set({
              drawing = true,
              icon = {
                drawing = true,
                string = icon,
                highlight = selected,
              },
              label = {
                drawing = false,
              },
            })
            updateStatusLabel(app, selected)
            app.app:subscribe({ "forced", "routine", "system_woke" }, function(env)
              updateStatusLabel(app, selected)
            end)
          else
            app.appName = nil
            app.app:set({
              drawing = (appIndex == 0) and true or false
            })
            app.statusLabel:set({
              drawing = false
            })
          end
        end

        -- Handle empty spaces
        if next(aerospaceApps) == nil then
          app = spaces[workspace].apps[1]
          app.app:set({
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
          -- "unsubscribe"
          app.app:subscribe({ "forced", "routine", "system_woke" }, function() end)
        end
      end)
    end)
  end
end

for spaceIndex, workspace in ipairs(workspaces) do
  local apps = {}
  local appNames = {}
  for appIndex = 0, maxAppsPerSpace, 1 do
    local app = sbar.add("item", "space." .. workspace .. ".app." .. appIndex, {
      drawing = (appIndex == 0) and true or false,
      update_freq = 10,
      icon = {
        drawing = false,
        font = settings.icons,
        padding_left = 5,
        padding_right = 5,
        color = colors.white,
        highlight_color = colors.accent_color,
        highlight = selected
      },
      label = {
        drawing = (appIndex == 0) and true or false,
        padding_left = 5,
        padding_right = 5,
        color = colors.white,
        font = {
          family = settings.font.numbers,
          size = 14.0,
        },
        highlight_color = colors.accent_color,
        highlight = selected,
        string = spaceNames[workspace],
      },
      padding_left = 2,
      padding_right = 2,
      background = {
        height = 24,
        corner_radius = 7,
        color = colors.transparent,
        border_color = colors.transparent
      },
    })

    local appStatusLabel = sbar.add("item", "space." .. workspace .. ".app." .. appIndex .. ".statusLabel", {
      drawing = false,
      padding_left = -13,
      padding_right = 2,
      y_offset = 5,
      icon = { drawing = false },
      label = {
        padding_left = 4,
        padding_right = 4,
        align = "center",
        y_offset = 1,
        font = {
          family = settings.font.numbers,
          size = 10.0,
        },
      },
      background = {
        height = 14,
        corner_radius = 7,
        color = colors.red,
        border_width = 0,
      }
    })

    app:subscribe("mouse.clicked", function(env)
      local SID = split(env.NAME, ".")[2]
      sbar.exec("aerospace workspace --fail-if-noop " .. SID)
    end)

    apps[appIndex] = {
      app = app,
      statusLabel = appStatusLabel,
      appName = appName,
    }
    table.insert(appNames, app.name)
    table.insert(appNames, appStatusLabel.name)
  end

  local space = sbar.add("bracket", "space." .. workspace, appNames, {
    background = {
      color = colors.bg1,
      border_width = 2
    }
  })

  spaces[workspace] = {
    space = space,
    apps = apps
  }

  sbar.add("item", "space." .. workspace .. ".padding", {
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
  print(env.PREV_WORKSPACE .. " -> " .. env.FOCUSED_WORKSPACE)
  prev_workspace = env.PREV_WORKSPACE
  current_workspace = env.FOCUSED_WORKSPACE
end)

space_window_observer:subscribe("aerospace_focus_change", function(env)
  updateSpaces()
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
