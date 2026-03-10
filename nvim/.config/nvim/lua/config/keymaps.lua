vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Git status" })
vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
vim.keymap.set("n", "<leader>q", "<cmd>qa!<cr>", { desc = "Quit all" })

vim.keymap.set("n", "<Esc>", "<cmd>nohls<cr>", { desc = "Clear search highlight" })

-- Diffview
vim.keymap.set("n", "<leader>gd", function()
  vim.fn.system("git fetch origin main")
  vim.cmd("DiffviewOpen origin/main...HEAD")
end, { desc = "Fetch & diff against main" })
vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })

-- Octo (GitHub PRs)
vim.keymap.set("n", "<leader>gp", "<cmd>Octo pr list<cr>", { desc = "List PRs" })
vim.keymap.set("n", "<leader>gr", "<cmd>Octo review start<cr>", { desc = "Start PR review" })
vim.keymap.set("n", "<leader>gs", "<cmd>Octo review submit<cr>", { desc = "Submit PR review" })
vim.keymap.set("n", "<leader>gR", "<cmd>Octo review resume<cr>", { desc = "Resume PR review" })
