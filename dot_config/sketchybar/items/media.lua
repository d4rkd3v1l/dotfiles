local settings = require("settings")
local icons = require("icons")
local colors = require("colors")

local accent_color = colors.green
sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")

local spotify_title = sbar.add("item", "spotify.title", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = {
    drawing = false,
  },
  label = {
    font = {
      -- family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
    color = colors.comment,
    max_chars = 10,
    string = "no title",
  },
  y_offset = -6,
})

local spotify_artist = sbar.add("item", "spotify.artist", {
  position = "right",
  padding_left = -5,
  icon = {
    drawing = false,
  },
  label = {
    font = {
      -- family = settings.font.numbers,
      style = settings.font.style_map["Heavy"],
      size = 10.0,
    },
    color = colors.comment,
    max_chars = 11,
    string = "no artist",
  },
  y_offset = 6,
})

local spotify_icon = sbar.add("item", {
  position = "right",
  icon = {
    font = settings.icons,
    color = colors.comment,
    string = ":spotify:",
  },
  padding_right = 0,
})

local spotify_bracket = sbar.add("bracket", "spotify.bracket", { spotify_icon.name, spotify_artist.name, spotify_title.name }, {
  background = {
    color = colors.bg1,
    border_color = colors.comment,
  },
  popup = {
    align = "center",
    height = 30,
  },
})

spotify_icon:subscribe("spotify_change", function(env)
  local is_playing = (env.INFO["Player State"] == "Playing")

  spotify_icon:set({
    icon = {
      color = is_playing and accent_color or colors.comment,
    },
  })

  spotify_artist:set({
    label = {
      string = env.INFO.Artist,
      color = is_playing and accent_color or colors.comment,
    },
  })

  spotify_title:set({
    label = {
      string = env.INFO.Name,
      color = is_playing and accent_color or colors.comment,
    },
  })

  spotify_bracket:set({
    background = {
      border_color = is_playing and accent_color or colors.comment,
    },
  })
end)
