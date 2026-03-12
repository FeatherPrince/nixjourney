{ config, lib, pkgs, userName, ... }:

{
  wsl = {
    enable = true;
    defaultUser = userName;
  };
}

# https://github.com/nix-community/NixOS-WSL
# note about WSL it behaves like a normal console that is alreade inside of a graphical environment