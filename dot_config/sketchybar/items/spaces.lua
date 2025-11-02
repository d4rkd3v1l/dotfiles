local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local window_pool_size = 10
local space_names = {}
space_names["1"] = "1"
space_names["2"] = "2"
space_names["3"] = "3"

local function map(tbl, f)
  local t = {}
  for k,v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

local function create_window_pool(space)
  local window_pool = {}

  for index = 1, window_pool_size, 1 do
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
      icon = {
        drawing = false,
      },
      label = {
        highlight_color = colors.accent_color,
        max_chars = 10,
        padding_left = 0,
        padding_right = 5,
      },
      padding_left = 2,
      padding_right = 2,
    })

    local window_item = {
      icon = icon,
      label = label,
      badge = badge,
    }

    table.insert(window_pool, window_item)
  end

  return window_pool
end

local function create_spaces(workspace_data)
  local spaces = {}

  for index, space_data in ipairs(workspace_data) do
    local items = {}

    local title = sbar.add("item", "space." .. index .. ".title", {
      icon = {
        drawing = false,
      },
      label = {
        string = space_data.title,
        color = colors.comment,
        highlight_color = colors.accent_color,
        font = {
          -- family = settings.font.numbers,
          style = settings.font.style_map["Heavy"],
          size = 10.0,
        },
        y_offset = 5,
      },
      padding_right = 0,
    })
    table.insert(items, title.name)

    local pool = create_window_pool(space_data)
    for _, item in ipairs(pool) do
      table.insert(items, item.icon.name)
      table.insert(items, item.badge.name)
      table.insert(items, item.label.name)
    end

    local space = sbar.add("bracket", "space." .. index, items, {
      background = {
        color = colors.bg1,
      }
    })

    sbar.add("item", "space." .. index .. ".padding", {
      script = "",
      width = settings.group_paddings,
    })

    local space_bracket = {
      bracket = space,
      title = title,
      pool = pool,
    }

    table.insert(spaces, space_bracket)
  end

  return spaces
end

function group_by(tbl, key)
  local grouped = {}
  for _, item in ipairs(tbl) do
    local group_value = item[key]
    if group_value ~= nil then
      grouped[group_value] = grouped[group_value] or {}
      table.insert(grouped[group_value], item)
    end
  end
  return grouped
end

local function get_aerospace_spaces(callback)
  sbar.exec("aerospace list-workspaces --all --format '%{workspace}%{workspace-is-focused}' --json", function(result)
    local data = map(result, function(item)
      local space_data = {
        index = item.workspace,
        title = space_names[item.workspace],
        is_focused = item["workspace-is-focused"],
      }
      return space_data
    end)
    callback(data)
  end)
end

local function get_aerospace_windows(callback)
  sbar.exec("aerospace list-windows --all --format '%{workspace}%{window-id}%{app-name}' --json", function(result)
    sbar.exec("aerospace list-windows --focused --format '%{window-id}' --json", function(focused_window_result)
      local focused_window_id = focused_window_result[1]["window-id"]
      local data = map(result, function(item)
        local window_data = {
          space_index = item["workspace"],
          window_id = item["window-id"],
          app_name = item["app-name"],
          is_focused = item["window-id"] == focused_window_id,
        }
        return window_data
      end)
      data = group_by(data, "space_index")
      callback(data)
      end)
  end)
end

local function update_badge(app_name, badge)
  -- Need to strip LTR marker \u200E as e.g. WhatsApp uses it
  sbar.exec("osascript ./helpers/statuslabel.applescript \"" .. app_name:gsub("\u{200E}", "") .. "\"", function(badge_count)
    local badge_count_as_number = tonumber(badge_count)
    local show_badge = badge_count_as_number == nil or badge_count_as_number ~= 0

    badge:set({
      drawing = show_badge,
      label = {
        string = badge_count
      }
    })
  end)
end

local function update_spaces(space_data, window_data)
  for space_index, space in ipairs(space_data) do
    spaces[space_index].title:set {
      label = {
        highlight = space.is_focused,
      },
    }

    spaces[space_index].bracket:set {
      background = {
        border_color = space.is_focused and colors.accent_color or colors.comment,
      }
    }

    spaces[space_index].title:subscribe("mouse.clicked", function()
      sbar.exec("aerospace workspace --fail-if-noop " .. space.index)
    end)

    for window_index = 1, window_pool_size, 1 do
      local window = window_data[space.index][window_index]
      local icon_item = spaces[space_index].pool[window_index].icon
      local label_item = spaces[space_index].pool[window_index].label
      local badge_item = spaces[space_index].pool[window_index].badge

      if window ~= nil then
        local lookup = app_icons[window.app_name]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)

        icon_item:set {
          drawing = true,
          icon = {
            string = icon,
            color = space.is_focused and colors.with_alpha(colors.accent_color, 0.4) or colors.comment,
            highlight = window.is_focused,
          },
        }

        label_item:set {
          drawing = true,
          label = {
            drawing = window.is_focused,
            string = window.app_name,
            highlight = window.is_focused,
          }
        }

        icon_item:subscribe("mouse.clicked", function()
          sbar.exec("aerospace focus --window-id " .. window.window_id)
        end)

        label_item:subscribe("mouse.clicked", function()
          sbar.trigger("swap_menus_and_spaces")
        end)

        badge_item:subscribe("mouse.clicked", function()
          sbar.exec("aerospace focus --window-id " .. window.window_id)
        end)

        update_badge(window.app_name, badge_item)
        icon_item:subscribe({ "forced", "routine", "system_woke" }, function()
          update_badge(window.app_name, badge_item)
        end)

      else
        icon_item:set {
          drawing = false
        }

        label_item:set {
          drawing = false
        }

        badge_item:set {
          drawing = false
        }

        -- "unsubscribe", no idea if this is necessary or even makes any sense
        icon_item:subscribe({ "mouse.clicked", "forced", "routine", "system_woke" }, function() end)
        label_item:subscribe({ "mouse.clicked", "forced", "routine", "system_woke" }, function() end)
        badge_item:subscribe({ "mouse.clicked", "forced", "routine", "system_woke" }, function() end)
      end
    end
  end
end

get_aerospace_spaces(function(space_data)
  get_aerospace_windows(function(window_data)
    spaces = create_spaces(space_data)
    update_spaces(space_data, window_data)
  end)
end)

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

space_window_observer:subscribe("aerospace_focus_change", function()
  get_aerospace_spaces(function(space_data)
    get_aerospace_windows(function(window_data)
      update_spaces(space_data, window_data)
    end)
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.trigger("swap_menus_and_spaces")

  get_aerospace_spaces(function(space_data)
    get_aerospace_windows(function(window_data)
      update_spaces(space_data, window_data)
    end)
  end)
end)
