{ config, lib, pkgs, userName, ... }:

{
  imports = [
    # include NixOS-WSL modules
    # inputs.nixos-wsl.nixosModules.default
    <nixos-wsl/modules>
  ];


  wsl = {
    enable = true;
    defaultUser = userName;
  };
}

# https://github.com/nix-community/NixOS-WSL
# note about WSL it behaves like a normal console that is alreade inside of a graphical environment