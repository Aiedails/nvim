vim.opt.background = "dark"

local function override(colors)
  local default = colors.palette
  local theme = colors.theme

  local overrides = {
    CmpDocumentation = { link = "Pmenu" },
    CmpItemKindField = { link = "@field" },
    CmpItemKindKeyword = { link = "@keyword.return" },
    CmpItemKindProperty = { link = "@property" },
    DiagnosticSignError = { bg = "#2A1C23" },
    DiagnosticSignHint = { bg = "#1C1E2A" },
    DiagnosticSignInfo = { bg = "#262729" },
    DiagnosticSignWarn = { bg = "#2F261A" },
    GitSignsAdd = { bg = default.sumiInk1 },
    GitSignsChange = { bg = default.sumiInk1 },
    GitSignsDelete = { bg = default.sumiInk1 },
    HighLightLineMatches = { bg = default.winterYellow },
    Pmenu = { bg = default.sumiInk3 },
    TelescopePromptNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1 },
    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
    TelescopePromptTitle = { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1 },
    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
    TelescopeResultsBorder = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_dim },
    TelescopeResultsTitle = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
    TelescopeTitle = { fg = theme.ui.special, bold = true },
    WinSeparator = { fg = default.sumiInk4 },
    CodeBlock = { bg = default.sumiInk0 },
    Headline1 = { bg = "#21001D" },
    Headline2 = { bg = "#151F2D" },
    Headline3 = { bg = default.sumiInk3 },
    ["@text.title.1"] = {
      fg = default.peachRed,
      bold = true,
    },
    ["@text.title.2"] = {
      fg = default.surimiOrange,
      bold = true,
    },
    ["@text.title.3"] = {
      fg = default.carpYellow,
      bold = true,
    },
    ["@text.title"] = {
      fg = default.crystalBlue,
      bold = true,
    },
    ["@text.reference"] = {
      fg = default.springBlue,
      italic = true,
    },
    ["@text.uri"] = {
      link = "Comment",
    },
  }

  return overrides
end

require("kanagawa").setup({
  undercurl = true, -- enable undercurls
  commentStyle = { italic = true },
  functionStyle = { bold = true },
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = { bold = true },
  variablebuiltinStyle = { italic = true },
  globalStatus = true,
  overrides = override,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
  background = {
    dark = "wave",
    light = "lotus",
  },
  transparent = true,
})

vim.cmd("colorscheme kanagawa")
