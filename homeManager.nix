{ pkgs, ... }:

{
  home-manager.users.feather = {
  home.stateVersion = "25.11";
  };

  users.users.feather = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      git
    ];
  };
}