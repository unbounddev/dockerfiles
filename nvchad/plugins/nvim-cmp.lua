return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    dir = "/projects/nvim-odoo",
    dev = true
  },
  opts = function(_, opts)
    table.insert(opts.sources, { name = "odoo" })
  end,
}
