# nixjourney
# Readme
an attempt at learning nix



# todo

- [ ] file with configuration variables that can be used in other files
- [ ] set up home manager
- [ ] set up flakes
- [ ] set up flakes.lock
- [ ] the final goal is to have a one line install that works on WSL and standalone




instalation
```
nixos-generate-config
nix-shell -p git
git clone https://github.com/FeatherPrince/nixjourney
```


generate a flake on a bare nix installation
```
nix flake init --extra-experimental-features nix-command --extra-experimental-features flakes
wrote: "/home/nixos/nixconfig/flake.nix
```


# Resources
[WSL](https://github.com/nix-community/NixOS-WSL)

[official website](https://nixos.org/)

[extranix](https://extranix.com/)

[MyNixOS](https://mynixos.com/)
