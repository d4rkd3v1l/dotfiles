local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local appIcons = require("helpers.app_icons")

local spaces = {}
local windowPoolSize = 10
local spaceNames = {}
spaceNames["1"] = "Tmux"
spaceNames["2"] = "Main"
spaceNames["3"] = "Misc"

function map(tbl, f)
  local t = {}
  for k,v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

local function createWindowPool(space)
  local windowPool = {}

  for index = 1, windowPoolSize, 1 do
    local icon = sbar.add("item", "space." .. space.index .. ".window." .. index .. ".icon", {
      drawing = false,
      update_freq = 10,
      icon = {
        font = settings.icons,
        padding_left = 5,
        padding_right = 5,
        color = colors.grey,
        highlight_color = colors.accent_color,
      },
      label = {
        drawing = false,
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

    local badge = sbar.add("item", "space." .. space.index .. ".window." .. index .. ".badge", {
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

    local label = sbar.add("item", "space." .. space.index .. ".window." .. index .. ".label", {
      drawing = false,
      update_freq = 10,
      icon = {
        drawing = false,
      },
      label = {
        highlight_color = colors.accent_color,
        -- max_chars = 10,
      },
      padding_left = 0,
      padding_right = 4,
      background = {
        height = 24,
        corner_radius = 7,
        color = colors.transparent,
        border_color = colors.transparent
      },
    })

    local windowItem = {
      icon = icon,
      label = label,
      badge = badge,
    }

    table.insert(windowPool, windowItem)
  end

  return windowPool
end

local function createSpaces(workspaceData)
  local spaces = {}

  for index, spaceData in ipairs(workspaceData) do
    local items = {}

    local title = sbar.add("item", "space." .. index .. ".title", {
      icon = {
        drawing = false,
      },
      label = {
        string = spaceData.title,
        color = colors.comment,
        highlight_color = colors.accent_color,
        font = {
          family = settings.font.numbers,
          style = settings.font.style_map["Bold"],
          size = 9.0,
        },
        y_offset = 4,
      },
    })
    table.insert(items, title.name)

    local pool = createWindowPool(spaceData)
    for index, item in ipairs(pool) do
      table.insert(items, item.icon.name)
      table.insert(items, item.badge.name)
      table.insert(items, item.label.name)
    end

    local space = sbar.add("bracket", "space." .. index, items, {
      background = {
        color = colors.bg1,
        border_width = 2,
      }
    })

    sbar.add("item", "space." .. index .. ".padding", {
      script = "",
      width = 5,
    })

    local spaceBracket = {
      bracket = space,
      title = title,
      pool = pool,
    }

    table.insert(spaces, spaceBracket)
  end

  return spaces
end

function groupBy(tbl, key)
  local grouped = {}
  for _, item in ipairs(tbl) do
    local groupValue = item[key]
    if groupValue ~= nil then
      grouped[groupValue] = grouped[groupValue] or {}
      table.insert(grouped[groupValue], item)
    end
  end
  return grouped
end

local function getAerospaceSpaces(callback)
  sbar.exec("aerospace list-workspaces --all --format '%{workspace}%{workspace-is-focused}' --json", function(result)
    local data = map(result, function(item) 
      local spaceData = {
        index = item.workspace,
        title = spaceNames[item.workspace],
        isFocused = item["workspace-is-focused"],
      }
      return spaceData
    end)
    callback(data)
  end)
end

local function getAerospaceWindows(callback)
  sbar.exec("aerospace list-windows --all --format '%{workspace}%{window-id}%{app-name}' --json", function(result)
    sbar.exec("aerospace list-windows --focused --format '%{window-id}' --json", function(focusedWindowResult)
      local focusedWindowId = focusedWindowResult[1]["window-id"]
      local data = map(result, function(item) 
        local windowData = {
          spaceIndex = item["workspace"],
          windowId = item["window-id"],
          appName = item["app-name"],
          isFocused = item["window-id"] == focusedWindowId,
        }
        return windowData
      end)
      data = groupBy(data, "spaceIndex")
      callback(data)
      end)
  end)
end

local function updateBadge(appName, badge)
  -- Need to strip LTR marker \u200E as e.g. WhatsApp uses it
  sbar.exec("osascript ./helpers/statuslabel.applescript \"" .. appName:gsub("\u{200E}", "") .. "\"", function(badgeCount)
    local badgeCountAsNumber = tonumber(badgeCount)
    local showBadge = badgeCountAsNumber == nil or badgeCountAsNumber ~= 0

    badge:set({
      drawing = showBadge,
      label = {
        string = badgeCount
      }
    })
  end)
end

local function updateSpaces(spaceData, windowData)
  for spaceIndex, space in ipairs(spaceData) do
    spaces[spaceIndex].title:set {
      label = {
        highlight = space.isFocused,
      },
    }

    spaces[spaceIndex].bracket:set {
      background = {
        border_color = space.isFocused and colors.accent_color or colors.bg2,
      }
    }

    spaces[spaceIndex].title:subscribe("mouse.clicked", function(env)
      sbar.exec("aerospace workspace --fail-if-noop " .. space.index)
    end)

    for windowIndex = 1, windowPoolSize, 1 do
      local window = windowData[space.index][windowIndex]
      local iconItem = spaces[spaceIndex].pool[windowIndex].icon
      local labelItem = spaces[spaceIndex].pool[windowIndex].label
      local badgeItem = spaces[spaceIndex].pool[windowIndex].badge

      if window ~= nil then
        local lookup = appIcons[window.appName]
        local icon = ((lookup == nil) and appIcons["Default"] or lookup)

        iconItem:set {
          drawing = true,
          icon = {
            string = icon,
            color = space.isFocused and colors.with_alpha(colors.accent_color, 0.4) or colors.comment,
            highlight = window.isFocused,
          },
        }

        labelItem:set {
          drawing = true,
          label = {
            drawing = window.isFocused,
            string = window.appName,
            highlight = window.isFocused,
          }
        }

        iconItem:subscribe("mouse.clicked", function(env)
          sbar.exec("aerospace focus --window-id " .. window.windowId)
        end)

        labelItem:subscribe("mouse.clicked", function(env)
          sbar.exec("aerospace focus --window-id " .. window.windowId)
        end)

        badgeItem:subscribe("mouse.clicked", function(env)
          sbar.exec("aerospace focus --window-id " .. window.windowId)
        end)

        updateBadge(window.appName, badgeItem)
        iconItem:subscribe({ "forced", "routine", "system_woke" }, function(env)
          updateBadge(window.appName, badgeItem)
        end)

      else
        iconItem:set {
          drawing = false
        }

        labelItem:set {
          drawing = false
        }

        badgeItem:set {
          drawing = false
        }

        -- "unsubscribe", no idea if this is necessary or even makes any sense
        iconItem:subscribe({ "mouse.clicked", "forced", "routine", "system_woke" }, function() end)
        labelItem:subscribe({ "mouse.clicked", "forced", "routine", "system_woke" }, function() end)
        badgeItem:subscribe({ "mouse.clicked", "forced", "routine", "system_woke" }, function() end)
      end
    end
  end
end

getAerospaceSpaces(function(spaceData)
  getAerospaceWindows(function(windowData)
    spaces = createSpaces(spaceData)
    updateSpaces(spaceData, windowData)
  end)
end)

--[[
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
        for appIndex = 0, windowPoolSize, 1 do
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
  for appIndex = 0, windowPoolSize, 1 do
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
        -- highlight = selected
      },
      label = {
        drawing = (appIndex == 0) and true or false,
        padding_left = 5,
        padding_right = 5,
        color = colors.white,
        font = {
          -- family = settings.font.numbers,
          -- size = 14.0,
        },
        highlight_color = colors.accent_color,
        -- highlight = selected,
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
]]

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

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true
})

space_window_observer:subscribe("aerospace_focus_change", function(env)
  getAerospaceSpaces(function(spaceData)
    getAerospaceWindows(function(windowData)
      updateSpaces(spaceData, windowData)
    end)
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")

  getAerospaceSpaces(function(spaceData)
    getAerospaceWindows(function(windowData)
      updateSpaces(spaceData, windowData)
    end)
  end)
end)
