return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signcolumn = true,
      numhl = false,
      linehl = false,
      watch_gitdir = {
        interval = 1000,
      },
      current_line_blame = false,
    },
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Ensure parsers are installed (async, no-op if already present)
      local parsers = {
        "bash", "c", "diff", "html", "javascript", "json", "lua",
        "markdown", "markdown_inline", "python", "query", "regex",
        "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
      }
      local installed = require("nvim-treesitter.config").get_installed()
      local installed_set = {}
      for _, p in ipairs(installed) do
        installed_set[p] = true
      end
      local missing = {}
      for _, p in ipairs(parsers) do
        if not installed_set[p] then
          table.insert(missing, p)
        end
      end
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      -- Enable treesitter highlighting and indentation for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select textobjects
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      -- Move to next/previous
      local move_maps = {
        ["]m"] = { move.goto_next_start, "@function.outer" },
        ["]]"] = { move.goto_next_start, "@class.outer" },
        ["]a"] = { move.goto_next_start, "@parameter.inner" },
        ["]M"] = { move.goto_next_end, "@function.outer" },
        ["]["] = { move.goto_next_end, "@class.outer" },
        ["[m"] = { move.goto_previous_start, "@function.outer" },
        ["[["] = { move.goto_previous_start, "@class.outer" },
        ["[a"] = { move.goto_previous_start, "@parameter.inner" },
        ["[M"] = { move.goto_previous_end, "@function.outer" },
        ["[]"] = { move.goto_previous_end, "@class.outer" },
      }
      for key, val in pairs(move_maps) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          val[1](val[2], "textobjects")
        end)
      end

      -- Swap parameters
      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })
    end,
  },

  -- LSP
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure all servers with shared capabilities
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Lua LS with neovim-specific settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })

      -- Enable all servers
      vim.lsp.enable({
        "lua_ls", "pyright", "ts_ls", "bashls", "jsonls", "yamlls", "html", "cssls",
      })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        end,
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Git diff viewer
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- GitHub PR reviews
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup({
        use_local_fs = true,
      })
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 300,
      })
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>r", group = "Rename" },
        { "<leader>d", group = "Document" },
      })
    end,
  },
}
