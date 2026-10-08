{ userName, pkgs,  ... }:

{
  home.username = "${userName}";
  home.homeDirectory = "/home/${userName}";

  # programs.oh-my-posh.enable = true;
  # programs.oh-my-posh.enableZshIntegration = true;
  # programs.oh-my-posh.useTheme = "";

  programs.bash = {
    enable = true;
    # bashrcExtra commands executed in non all shells including non interactive ones
    # bashrcExtra = "";
    shellAliases = {
      ls        = "eza --icons=always -X -F=always";
      cat       = "bat";
      yt-dlp    = "yt-dlp -P $(xdg-user-dir VIDEOS)/yt-dlp";
      sops-edit = "sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops ~/nixjourney/secrets/featherlabs.yaml";
      # nrs = "sudo nixos-rebuild switch";
    };
    # initExtra commands executed in interactive shells
    initExtra = "bind 'set completion-ignore-case on'";
  };

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };

    settings = {
      credential.helper = "libsecret";
    };
  };

  programs.lutris = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+c" = "copy_and_clear_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
      ];
    };
  };

  programs.mpv = {
    enable = true;
    scripts = [
      pkgs.mpvScripts.mpris
      pkgs.mpvScripts.modernz
      pkgs.mpvScripts.thumbfast
    ];
    bindings = { };
    config = {
      "autofit-larger" = "95%x95%";
      save-watch-history = true;
      save-position-on-quit = true;
      write-filename-in-watch-later-config = true;
    };
  };faewf

  programs.yt-dlp.enable = true;
  # programs.yt-dlp.extraConfig = ''-P $(xdg-user-dir VIDEOS)/yt-dlp''; # this works, just not when used in the config
}
