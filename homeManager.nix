{ pkgs, userName , ... }:

{
  # home-manager.extraSpecialArgs = { inherit userName; };  
  home-manager.users.${userName} = {
  home.stateVersion = "25.11";
  };

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      git
    ];
  };
}

# https://github.com/nix-community/home-manager