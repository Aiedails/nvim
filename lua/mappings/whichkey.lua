local ok, wk = pcall(require, "which-key")
if not ok then
  require("core.utils").errorL("which key fail to load: " .. wk, "which-key")
  return
end

local keys = {
  gi = {
    name = "+Git",
    B = "Toggle git blame (Popup Panel)",
    b = "Toggle inline git blame (Virtual text)",
    c = "Commit staged changes",
    D = "Toggle diff panel",
    d = "Toggle diff panel",
    h = "Toggle deleted",
    j = "Jump to next hunk",
    k = "Jump to previouse hunk",
    P = "Create a git push prompt",
    p = "Preview current diff",
    r = "Reset current hunk",
    R = "Reset whole buffer",
    S = "Stage current buffer",
    s = "Stage current hunk",
    u = "Undo staged hunk",
  },
  [";"] = {
    name = "+Quick Operation",
    d = "Open cmdline to dispatch commands",
    f = "Open quick find file panel",
    g = "Open git status panel",
    h = "Jump to left window",
    j = "Jump to below window",
    k = "Jump to upper window",
    l = "Jump to right window",
    p = "Enter buffer pick mode",
    q = "Quit current buffer",
    s = "Open live grep panel",
    t = "Open tree file manager",
    w = "Save buffer to file",
  },
  gc = {
    name = "+Comments (Line)",
    c = { "Comment current line" },
  },
  gb = {
    name = "+Comments (Block)",
    c = { "Comment with block comment" },
  },
  ["<leader>"] = {
    l = "Open lazygit",
    r = {
      name = "Rust keymap (Available in Rust buffer only)",
      r = { "Open runnable" },
      a = { "Trigger actions" },
    },
  },
  ["<C-t>"] = {
    l = "Next tab",
    h = "Previous tab",
    n = "New tab",
  },
  g = {
    a = { "Trigger LSP code action" },
    d = { "Preview definition" },
    h = { "View document" },
    s = { "Open signature help" },
    o = { "Show diagnostic for current line" },
    j = { "Jump to next diagnostic" },
    k = { "Jump to previous diagnostic" },
    r = { "Rename current symbol" },
    D = { "Jump to symbol definition" },
    m = { "Jump to symbol implementation" },
    t = { "Jump to type definition" },
    q = { "Set loclist" },
    f = { "Format current buffer" },
  },
}

wk.register(keys)

-- Treesitter text object
local text_objects = {
  ["af"] = "function (AROUND)",
  ["if"] = "function (INNER)",
  ["ac"] = "class (AROUND)",
  ["ic"] = "class (INNER)",
  ["ab"] = "block (AROUND)",
  ["ib"] = "block (INNER)",
  ["al"] = "function call (AROUND)",
  ["il"] = "function call (INNER)",
  ["ap"] = "parameter (AROUND)",
  ["ip"] = "parameter (INNER)",
  ["ao"] = "condition (AROUND)",
  ["io"] = "condition (INNER)",
  ["as"] = "statement (AROUND)",
}

wk.register(text_objects, { mode = "o", prefix = "" })
