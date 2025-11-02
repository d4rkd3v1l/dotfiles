local icons = require("icons")
local colors = require("colors")

local accent_color = colors.green
sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")

local spotify_item = sbar.add("item", {
  position = "right",
  icon = {
    color = accent_color,
    string = ":spotify:",
  },
})

local spotify_artist = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  width = 0,
  icon = { drawing = false },
  label = {
    -- width = 0,
    font = { size = 9 },
    color = colors.with_alpha(colors.white, 0.6),
    max_chars = 18,
    y_offset = 6,
  },
})

local spotify_title = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = false },
  label = {
    font = { size = 11 },
    -- width = 0,
    max_chars = 12,
    y_offset = -5,
  },
})

local spotify_bracket = sbar.add("bracket", "spotify.bracket", { spotify_item.name, spotify_artist.name, spotify_title }, {
  background = {
    color = colors.bg1,
    border_color = accent_color,
  },
  popup = {
    align = "center",
    height = 30,
  },
})

spotify_item:subscribe("spotify_change", function(env)
  local drawing = (env.INFO["Player State"] == "Playing")
  spotify_artist:set({
    drawing = drawing,
    label = {
      string = env.INFO.Artist,
    },
  })

  spotify_title:set({
    drawing = drawing,
    label = {
      string = env.INFO.Name,
    },
  })
end)
