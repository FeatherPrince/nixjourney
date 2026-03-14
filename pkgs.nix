{ pkgs, ... }:

{
    programs.firefox.enable = true;
    environment.systemPackages = with pkgs; [
    feh
    mpv

    bat
    eza
    ncdu
    skim
    fastfetch
    yt-dlp
    btop
    git
    ripgrep
    fd	#	search for strings inside of files
    nsh	#	search for file names

    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions

    firefox
    wezterm
    vscodium
    bitwarden-desktop

    discord
    
    gimp
    blender
    libreoffice-fresh
    ];
}
