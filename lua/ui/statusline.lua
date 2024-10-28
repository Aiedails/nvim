local gl = require("galaxyline")
local gls = gl.section

local colors = {
  bg = "#16161D",
  fg = "#b2b2b9",
  black = "#191919",
  yellow = "#E5C07B",
  cyan = "#70C0BA",
  dimblue = "#83A598",
  green = "#98C379",
  orange = "#FF8800",
  purple = "#C678DD",
  magenta = "#D27E99",
  blue = "#81A1C1",
  red = "#D54E53",
  lightgrey = "#5a5a72",
}

if vim.g.colors_name == "mellifluous" then
  colors.bg = "#282724"
end

--[[ local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 30 then
    return true
  end
  return false
end ]]

--[[ local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end ]]

-- insert_left insert item at the left panel
local function insert_left(element)
  table.insert(gls.left, element)
end

local function insert_space_on_left()
  insert_left({
    SpaceOnLeft = {
      provider = function()
        return " "
      end,
      highlight = { colors.bg, colors.bg },
    },
  })
end

local function insert_right(element)
  table.insert(gls.right, element)
end

local function insert_space_on_right()
  insert_right({
    SpaceOnRight = {
      provider = function()
        return " "
      end,
      highlight = { colors.bg, colors.bg },
    },
  })
end

-----------------------------------------------------
----------------- start insert ----------------------
-----------------------------------------------------
-- { mode panel start
local vim_mode = {
  alias = {
    n = "",
    no = "󰌌",
    nov = "󰌌",
    noV = "󰌌",
    i = "󰏫",
    c = "",
    v = "",
    V = "",
    [""] = "󰩬",
    C = "",
    ["r?"] = "?",
    rm = "",
    R = "",
    Rv = "",
    s = "󰆽",
    S = "󰆽",
    ["r"] = "󰌑",
    [""] = "󰆽",
    t = "",
    ["!"] = "",
    _LineLeap = "󱕘",
  },
  color = {
    n = colors.green,
    i = colors.yellow,
    v = colors.blue,
    [""] = colors.blue,
    V = colors.blue,
    c = colors.magenta,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    [""] = colors.orange,
    ic = colors.yellow,
    R = colors.purple,
    Rv = colors.purple,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ["r?"] = colors.cyan,
    ["!"] = colors.red,
    t = colors.red,
    _LineLeap = colors.red,
  },
  is_line_leap = false,
}

insert_left({
  ViModeIcon = {
    provider = function()
      -- auto change color according the vim mode
      local mode = vim.fn.mode()
      if vim_mode.is_line_leap then
        mode = "_LineLeap"
      end
      vim.api.nvim_set_hl(0, "GalaxyViMode", { fg = vim_mode.color[mode], bg = colors.bg })
      return "▊ " .. vim_mode.alias[mode]
    end,
    highlight = "GalaxyViMode",
  },
})

local gid = vim.api.nvim_create_augroup("LineLeapStatus", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "LeapEnter",
  group = gid,
  callback = function()
    vim_mode.is_line_leap = true
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "LeapLeave",
  group = gid,
  callback = function()
    vim_mode.is_line_leap = false
  end,
})

insert_space_on_left()

insert_right({
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = { colors.red, colors.bg },
  },
})
insert_right({
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = { colors.yellow, colors.bg },
  },
})
insert_right({
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = "  ",
    highlight = { colors.dimblue, colors.bg },
  },
})
insert_right({
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = "  ",
    highlight = { colors.dimblue, colors.bg },
  },
})

insert_right({
  FileIcon = {
    provider = "FileIcon",
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color,
      colors.bg,
    },
  },
})

insert_right({
  GetLspClient = {
    provider = "GetLspClient",
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color,
      colors.bg,
    },
  },
})

insert_space_on_right()

insert_right({
  TextIcon = {
    provider = function()
      return " 󰈚 "
    end,
    highlight = { colors.lightgrey, colors.bg },
  },
})

insert_right({
  LineColumn = {
    provider = "LineColumn",
    highlight = { colors.lightgrey, colors.bg },
  },
})

-- ============================= short line ===============================

local BufferTypeMap = {
  ["DiffviewFiles"] = " Diff View",
  ["FTerm"] = "Terminal",
  ["Mundo"] = "Mundo History",
  ["MundoDiff"] = "Mundo Diff",
  ["NeogitCommitMessage"] = " Neogit Commit",
  ["NeogitPopup"] = " Neogit Popup",
  ["NeogitStatus"] = " Neogit Status",
  ["NvimTree"] = " Tree",
  ["dap-repl"] = " Dap REPL",
  ["dapui_breakpoints"] = " Dap Breakpoints",
  ["dapui_scopes"] = "󱄑 Dap Scope",
  ["dapui_stacks"] = " Dap Stacks",
  ["dapui_watches"] = " Dap Watch",
  ["fern"] = " Fern FM",
  ["neo-tree"] = "󰙅 NeoTree",
  ["fugitive"] = " Fugitive",
  ["floggraph"] = " Git Log",
  ["fugitiveblame"] = " Fugitive Blame",
  ["git"] = " Git",
  ["help"] = "󰞋 Help",
  ["minimap"] = "Minimap",
  ["neoterm"] = " NeoTerm",
  ["qf"] = " Quick Fix",
  ["tabman"] = "Tab Manager",
  ["tagbar"] = "Tagbar",
  ["toggleterm"] = " ToggleTerm",
  ["Trouble"] = " Diagnostic",
  ["neo-term"] = " NeoTerm",
  ["noice"] = " noice",
  ["TelescopePrompt"] = " Telescope",
}

gl.short_line_list = vim.tbl_keys(BufferTypeMap)

require("galaxyline").section.short_line_left = {
  {
    ShortLineLeftBufferType = {
      highlight = { colors.lightgrey, colors.bg },
      provider = function()
        local name = BufferTypeMap[vim.bo.filetype]
        return string.format("▊ %s", name)
      end,
    },
  },
  {
    WinSeparator = {
      highlight = { colors.bg, colors.bg },
      provider = function()
        return " "
      end,
    },
  },
}

require("galaxyline").load_galaxyline()
