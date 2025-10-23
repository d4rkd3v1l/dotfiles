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

    sbar.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' --json ", function(aerospaceApps)
      local selected = current_workspace == workspace
      local no_app = true

      -- Update space indicator
      spaces[workspace].apps[0]:set({
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

      -- Update apps (windows)
      sbar.animate("tanh", 10, function()
        for appIndex = 0, maxAppsPerSpace, 1 do
          local aerospaceApp = aerospaceApps[appIndex]
          if aerospaceApp ~= nil then
            local appName = aerospaceApp["app-name"]
            local lookup = appIcons[appName]
            local icon = ((lookup == nil) and appIcons["Default"] or lookup)

            local app = spaces[workspace].apps[appIndex]
            app:set({
              drawing = true,
              icon = {
                drawing = true,
                string = icon,
                -- color = (appName == "Signal") and colors.pink or colors.white,
                highlight = selected,
              },
              label = {
                -- drawing = false,
                highlight = selected,
              },
              background = {
                -- color = (appName == "Microsoft Teams") and colors.pink or colors.transparent,
              }
            })
            sbar.exec("osascript ./helpers/statuslabel.applescript \"" .. appName .. "\"", function(statusLabel)
              if tonumber(statusLabel) > 0 then
                app:set({ label = { drawing = true, string = "(" .. statusLabel .. ")" }})
              else 
                app:set({ label = { drawing = false }})
              end
            end)
            app:subscribe({ "forced", "routine", "system_woke" }, function(env)
              sbar.exec("osascript ./helpers/statuslabel.applescript \"" .. appName .. "\"", function(statusLabel)
                if tonumber(statusLabel) > 0 then
                  app:set({ label = { drawing = true, string = "(" .. statusLabel .. ")" }})
                else 
                  app:set({ label = { drawing = false }})
                end
              end)
            end)
          else
            spaces[workspace].apps[appIndex]:set({
              drawing = (appIndex == 0) and true or false
            })
          end
        end

        -- Handle empty spaces
        if next(aerospaceApps) == nil then
            sbar.set("space." .. workspace .. ".app.1", {
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
        padding_left = 10,
        padding_right = 6,
        color = colors.white,
        font = {
          family = settings.font.numbers,
          size = 14.0,
        },
        highlight_color = colors.accent_color,
        highlight = selected,
        string = workspace,
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

    apps[appIndex] = app
    appNames[appIndex] = app.name -- TODO: use a kinda map function
  end

  local space = sbar.add("bracket", "space." .. workspace, appNames, {
    background = {
      color = colors.bg1
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
  current_workspace = env.FOCUSED_WORKSPACE
end)

space_window_observer:subscribe("aerospace_focus_change", function(env)
  updateSpaces()
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
