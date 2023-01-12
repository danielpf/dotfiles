local notify = require("notify")
vim.notify = notify

notify.setup({
  background_color = "ffb86c",
  render = "minimal",
  top_down = false,
  timeout = 3000
})

