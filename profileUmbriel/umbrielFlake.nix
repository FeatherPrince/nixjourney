# flake inputs
umbriel.url = "git+https://github.com/noctalia-dev/umbriel";

# NixOS
imports = [ inputs.umbriel.nixosModules.default ];
programs.umbriel.enable = true;

# home-manager
imports = [ inputs.umbriel.homeModules.default ];
programs.umbriel = {
  enable = true;
  settings = {
    general.autostart = [ "noctalia" ];
    layout.gap = 5;
    input.keyboard.layout = "de";
    keybinds = {
      "Mod+Return" = "spawn:kitty";
      "Mod+Q" = "window-close";
      "Mod" = "spawn:noctalia msg panel-toggle launcher";
    };
  };
};
