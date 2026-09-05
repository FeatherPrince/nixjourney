{ pkgs, userName , ... }:

{
  # home-manager.extraSpecialArgs = { inherit userName; };
  home-manager.users.${userName} = {
  home.stateVersion = "25.11";
  };

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

    ];
  };
}

# https://github.com/nix-community/home-manager
