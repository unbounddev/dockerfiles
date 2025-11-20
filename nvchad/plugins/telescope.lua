return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>ffh", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find Files (Hidden/Ignored)"}
  },
  opts = {
    pickers = {
      live_grep = {
        additional_args = function()
          return {"--hidden", "--no-ignore-vcs"}
        end
      }
    }
  }
}
