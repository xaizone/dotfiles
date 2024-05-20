return {
    "ellisonleao/gruvbox.nvim",
    config = function()
        require("gruvbox").setup({
            terminal_colors = true,
            transparent_mode = true,
            italic = {
                comments = false,
            },
        })
        vim.cmd("colorscheme gruvbox")
    end
}
