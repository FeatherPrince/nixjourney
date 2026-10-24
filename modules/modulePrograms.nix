{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    # extraPackages = with pkgs; [
    #   kdePackages.breeze
    # ];
    # package = pkgs.steam.override {
    #   extraEnv = {
    #     XCURSOR_THEME = "Breeze";
    #     XCURSOR_SIZE  = "24";
    #   };
    # };
  };
}
