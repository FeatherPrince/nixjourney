{ pkgs, userName , ... }:

{
  # home-manager.extraSpecialArgs = { inherit userName; };  
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

# https://github.com/nix-community/home-manager