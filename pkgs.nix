{ pkgs, ... }:

{
    programs.firefox.enable = true;
    environment.systemPackages = with pkgs; [
    # this sounds like a reasonable way of splitting packages: tty, tui, gui, plugin, daemon/service
    #######
    # tty #
    #######
    bat
    eza
    ncdu
    skim
    fastfetch
    yt-dlp
    git
    ripgrep
    fd	#	search for strings inside of files
    nsh	#	search for file names
    #######
    # tui #
    #######
    btop
    #######
    # gui #
    #######
    mpv
    firefox
    wezterm
    vscodium
    bitwarden-desktop
    discord
    gimp
    blender
    libreoffice-stable
    zed-editor-fhs
    # ollama
    # ollama-vulkan
    ollama-rocm
    # ollama-cuda
    # ollama-cpu
    # feh # requires x11
    ###########
    # plugins #
    ###########
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    ];
}
