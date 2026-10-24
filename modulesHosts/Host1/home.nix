{ pkgs, userName , ... }:


{
  home-manager.users.${userName} = {
  home.stateVersion = "26.05";
  };

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

    ];
  };

  imports = [
    ./home/homeZsh.nix
    ./home/homeNeovim.nix
  ];

  home.shellAliases = {
    ls        = "eza --icons=always -F=always";
    ll        = "eza --icons=always -F=always -l";
    la        = "eza --icons=always -F=always -a";
    lt        = "eza --icons=always -F=always --tree";
    lla       = "eza --icons=always -F=always -la";
    cat       = "bat";
    yt-dlp    = "yt-dlp -P $(xdg-user-dir)/yt-dlp --throttled-rate 100K";
    sops-edit = "sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops ~/nixjourney/secrets/featherlabs.yaml"; # SOPS_EDITOR=nvim
    vi        = "nvim";
    vim       = "nvim";
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
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
    themeFile = "Catppuccin-Mocha"; # SpaceGray_Eighties
    keybindings = {
      "ctrl+c" = "copy_and_clear_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };
    settings = {
      # cursor                         = "#d5071c";
      # cursor_text_color              = "#111111";
      # cursor_trail_color             = "#d5071c";
      # shell_integration              = "no-cursor";
      cursor_shape                 = "beam";
      cursor_trail                 = 20;      # Enable the cursor trail effect (value is in milliseconds)
      cursor_trail_decay           = "0.25 0.5"; # Fastest decay time: 0.1s, Slowest decay time: 0.4s
      cursor_trail_start_threshold = 0;         #
      background_opacity           = 0.5; #
      background_blur              = 64; #
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
      volume = 50;
    };
  };

  programs.yt-dlp.enable = true;
  # programs.yt-dlp.extraConfig = ''-P $(xdg-user-dir VIDEOS)/yt-dlp''; # this works, just not when used in the config
}
