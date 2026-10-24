{ userName, pkgs,  ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = catppuccin-nvim; config = "vim.cmd('colorscheme catppuccin-mocha')"; } #Or catppuccin-latte, etc.
      # treesitter is allegendly baked into nvim >= 12
      # { plugin = which-key-nvim; settings = { preset = "helix"; }; } # classic modern helix - options
    ];
  };

#   programs.nixvim = {
#     enable = true;
#     defaultEditor = true;
#     globals.mapleader = " ";
#     nixpkgs.source = inputs.nixpkgs;
#     keymaps = [
#       {
#         mode = "n";
#         key = "<leader>t";
#         action = "<cmd>echo 'Test!'<cr>";
#         options.desc = "Test Command";
#       }
#     ];
#     colorschemes.catppuccin = { enable = true; settings.flavour = "mocha"; }; #Or catppuccin-latte, etc.
#     # treesitter is allegendly baked into nvim >= 12
#     plugins.which-key = { enable = true; settings = { preset = "helix"; delay = 200; }; }; # classic modern helix - options
#     plugins.mini-icons.enable = true;
#     plugins.web-devicons.enable = true;
#     plugins.blink-cmp = {
#       enable = true;
#       settings = {
#         # Enable the cmdline source for command-line completion
#         sources = {
#           cmdline = [ ]; # This enables the default cmdline source
#         };
#
#         # Configure documentation to show automatically
#         completion.documentation = {
#           auto_show = true;
#           auto_show_delay_ms = 200; # Adjust delay as needed
#         };
#
#         # Ensure the cmdline menu appears automatically
#         cmdline.completion.menu.auto_show = true;
#
#         # Use a keymap preset that works well with cmdline
#         keymap.preset = "cmdline"; # or "inherit" if you have a custom preset
#       };
#     };
#   };
}
