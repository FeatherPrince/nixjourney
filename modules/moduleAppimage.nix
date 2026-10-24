{ pkgs, ... }:

{
  # systemd.tmpfiles.rules = [
  #   "d /srv/appimage-library                      2775 root    media -"
  # ];
  # environment.systemPackages = with pkgs; [
  #   appimage-run
  # ];
  # programs.appimage = {
  #   enable = true;
  #   # binfmt = true;
  #   package = pkgs.appimage-run;
  # };
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [ libepoxy libthai ];
    };
  };
}
