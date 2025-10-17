return {
  black = 0xff282a36,
  white = 0xfff8f8f2,
  comment = 0xff6272a4,
  red = 0xffFF5555,
  green = 0xff50fa7b,
  blue = 0xff8be9fd,
  yellow = 0xfff1fa8c,
  orange = 0xffffb86c,
  pink = 0xffff79c6,
  purple = 0xffbd93f9,
  grey = 0xff44475A,
  transparent = 0x00000000,

  bar = {
    bg = 0xff282a36,
    border = 0xff6272a4,
  },
  popup = {
    bg = 0xff282a36,
    border = 0xff6272a4,
  },
  bg1 = 0xff363944,
  bg2 = 0xff414550,

  workspace_colors = { 0xffbd93f9, 0xffffb86c, 0xff8be9fd, 0xffff79c6, 0xff50fa7b, 0xfff1fa8c },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
