local register = require("pack").register

-- Auto-pairs key mappings
register("hrsh7th/nvim-insx", {
  event = "InsertEnter",
  branch = "main",
  config = function()
    require("insx.preset.standard").setup()
  end,
})

-- Neovim API completion sources
register("ii14/emmylua-nvim", {
  lazy = true,
})

-- Neovim Library wrapper
register("nvim-lua/plenary.nvim", {
  lazy = true,
})

-- UI Library
register("MunifTanjim/nui.nvim", {
  lazy = true,
})

register("nvim-neo-tree/neo-tree.nvim", {
  branch = "v3.x",
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd("Neotree position=current")
          return
        end

        -- User might using stdin
        local first_arg = vim.fn.argv(0)
        if not first_arg or #first_arg == 0 or first_arg == "-" then
          return
        end

        vim.loop.fs_stat(
          first_arg,
          vim.schedule_wrap(function(err, stat)
            if err then
              vim.notify(
                "Unexpected file handle error from neo-tree: " .. err,
                vim.log.levels.ERROR
              )
              return
            end

            if stat.type ~= "directory" then
              return
            end

            vim.cmd("Neotree " .. first_arg)
          end)
        )
      end,
    })
  end,
  config = function()
    vim.g.neo_tree_remove_legacy_commands = 1

    require("neo-tree").setup({
      close_if_last_window = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      open_files_do_not_replace_types = {
        "terminal",
        "trouble",
        "qf",
        "diff",
        "fugitive",
        "fugitiveblame",
        "notify",
      },
      window = {
        width = 28,
      },
    })
  end,
  -- End of config
  keys = {
    {
      "<leader>t",
      "<CMD>Neotree action=focus toggle=true reveal=true position=left<CR>",
      desc = "Open file tree",
    },
    {
      "gO",
      "<CMD>Neotree action=focus toggle=true source=document_symbols position=float<CR>",
      desc = "View document symbols",
    },
  },
  cmd = {
    "Neotree",
  },
})

local function my_ivy(opt)
  local my_opt = {
    borderchars = {
      prompt = { " " },
      results = { " " },
      preview = { " " },
    },
  }
  local exted = vim.tbl_deep_extend("force", my_opt, opt or {})
  return require("telescope.themes").get_ivy(exted)
end

-- Fuzzy Picker
register("nvim-telescope/telescope.nvim", {
  lazy = true,
  config = function()
    require("telescope").setup({
      defaults = {
        prompt_prefix = "  ",
        entry_prefix = "  ",
      },
    })
  end,
  keys = {
    {
      "<leader>ff",
      function()
        local function my_find_file(opt)
          if not vim.b._is_inside_git_worktree then
            vim.fn.system("git rev-parse --is-inside-work-tree")
            vim.b._is_inside_git_worktree = vim.v.shell_error == 0
          end
          if vim.b._is_inside_git_worktree then
            return require("telescope.builtin").git_files(opt)
          else
            return require("telescope.builtin").find_files(opt)
          end
        end

        my_find_file(my_ivy({ hidden = true }))
      end,
      desc = "Find file",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols(my_ivy())
      end,
      desc = "Find symbol",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep(my_ivy())
      end,
      desc = "Find keyword",
    },
    {
      "<leader>fp",
      function()
        require("telescope.builtin").buffers(my_ivy({
          sort_mru = true,
          show_all_buffers = false,
          previewer = false,
        }))
      end,
      desc = "Select buffer",
    },
  },
})

-- Quick select for text objects
register("gcmt/wildfire.vim", {
  keys = "<Enter>",
})

-- Surround operation
register("kylechui/nvim-surround", {
  keys = {
    "ys",
    "yS",
    "cs",
    "cS",
    "ds",
    "dS",
    { "gs", mode = { "x", "n" } },
    { "gS", mode = { "x", "n" } },
    { "<C-g>", mode = "i" },
  },
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        visual = "gs",
      },
      -- add new object "y" for operating on Types. For example: `Vector<String>`
      surrounds = {
        ["y"] = {
          add = function()
            local result = require("nvim-surround.config").get_input("Enter the type name: ")
            if result then
              return { { result .. "<" }, { ">" } }
            end
          end,
          find = function()
            return require("nvim-surround.config").get_selection({
              pattern = "[^=%s%(%)]+%b<>",
            })
          end,
          delete = "^(.-<)().-(>)()$",
          change = {
            target = "^.-([%w_]+)()<.->()()$",
            replacement = function()
              local result =
                require("nvim-surround.config").get_input("Enter new type replacement: ")
              if result then
                return { { result }, { "" } }
              end
            end,
          },
        },
      },
    })
  end,
})

-- Quick moving by two character searching
register("ggandor/leap.nvim", {
  keys = {
    "s",
    "S",
    { "s", mode = "x" },
    { "S", mode = "x" },
    { "gj", require("tools.line_leap").leap_to_line, desc = "Leap to line" },
  },
  config = function()
    require("leap").add_default_mappings()
    require("leap").opts.safe_labels = {}
  end,
})

-- Quick moving by one character searching
register("ggandor/flit.nvim", {
  keys = {
    "f",
    "F",
    "t",
    "T",
  },
  config = function()
    require("flit").setup()
  end,
})

-- sort the number or text
register("sQVe/sort.nvim", {
  config = function()
    require("sort").setup({})
  end,
  cmd = "Sort",
})

-- Better search and replace (With Rust regex)
-- Load it with command `:Sed`
register("windwp/nvim-spectre", {
  lazy = true,
  init = function()
    vim.api.nvim_create_user_command("Sed", function()
      require("spectre").open()
    end, {})
  end,
})

-- Highlight search matches
register("kevinhwang91/nvim-hlslens", {
  keys = {
    {
      "n",
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    },
    {
      "N",
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    },
    { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
    { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
    { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
    { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
  },
  config = function()
    require("hlslens").setup()
    require("scrollbar.handlers.search").setup()
  end,
})

-- Auto matically setting tab width by projects
register("tpope/vim-sleuth")

--- Color utils
register("uga-rosa/ccc.nvim", {
  config = function()
    require("ccc").setup()
  end,
  cmd = {
    "CccPick",
    "CccHighlighterEnable",
  },
})

-- Multiple Cursor
register("mg979/vim-visual-multi", {
  keys = {
    "un",
    "<C-down>",
    "<C-up>",
    "uA",
    "ux",
    { mode = "x", "ux" },
    { mode = "x", "uA" },
    { mode = "x", "ua" },
    { mode = "x", "uf" },
    { mode = "x", "uc" },
  },
  init = function()
    -- remove the original key mappings. It is mapped to <C-z> already
    vim.keymap.set("n", "u", "<nop>")
    vim.keymap.set("x", "u", "<nop>")

    -- then, update the visual multi key mappings
    vim.g.VM_maps = {
      ["Find Under"] = "un",
      ["Find Subword Under"] = "un",
      ["Select Cursor Down"] = "<C-down>",
      ["Select Cursor Up"] = "<C-up>",
      ["Select All"] = "uA",
      ["Undo"] = "<C-z>",
      ["Redo"] = "<C-r>",
      ["Start Regex Search"] = "ux",
      ["Visual Regex"] = "ux",
      ["Visual All"] = "uA",
      ["Visual Add"] = "ua",
      ["Visual Find"] = "uf",
      ["Visual Cursors"] = "uc",
    }
  end,
})

-- Easy aligning text
register("junegunn/vim-easy-align", {
  cmd = "EasyAlign",
  keys = { { "<space>e", ":EasyAlign<CR>", mode = "x" } },
})

-- Show key stroke
register("folke/which-key.nvim", {
  event = "VeryLazy",
  config = function()
    local whichkey = require("which-key")
    whichkey.setup({})

    local ngrp = {
      mode = "n",
      ["g"] = { name = "+LSP" },
      ["<leader>g"] = { name = "+Git" },
      ["<leader>f"] = { name = "+Telescope" },
    }
    whichkey.register(ngrp)
  end,
})

-- Split and Join
register("Wansmer/treesj", {
  keys = {
    {
      "<leader>sj",
      function()
        require("treesj").toggle()
      end,
      desc = "Split or Join multiple line",
    },
  },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
})

local function gen_spider_keys()
  local keys = { "w", "e", "b" }
  local final = {}
  for _, k in ipairs(keys) do
    table.insert(final, {
      k,
      function()
        require("spider").motion(k)
      end,
      desc = "Spider motion " .. k,
    })
  end
  return final
end
register("chrisgrieser/nvim-spider", {
  keys = gen_spider_keys(),
  lazy = true,
})
