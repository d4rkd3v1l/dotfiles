return {
  "nvzone/typr",
  dependencies = "nvzone/volt",
  opts = {
    mode = "phrases", -- words, phrases
    winlayout = "responsive",
    kblayout = "qwerty",
    wpm_goal = 100,
    numbers = false,
    symbols = false,
    random = false,
    phrases = nil, -- can be a table of strings
    insert_on_start = false,
  },
  cmd = { "Typr", "TyprStats" },
}
