sudo nix-store -q --references /var/run/current-system/sw | cut -d'-' -f2- > currentlyInstalledPackages
sudo nixos-rebuild switch --flake --impure