sudo nix-store -q --references /var/run/current-system/sw | cut -d'-' -f2- > "currentlyInstalledPackages"
sudo nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes 
sudo nixos-rebuild switch --flake --impure
sudo nix-store -q --references /var/run/current-system/sw | cut -d'-' -f2- > "upgradedPackages"
diff currentlyInstalledPackages upgradedPackages
rm currentlyInstalledPackages
rm upgradedPackages
# add an information about downgrades/upgrades or when nothing was upgraded

# sudo nixos-rebuild switch --flake .#nixos --impure
