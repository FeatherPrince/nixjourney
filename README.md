# nixjourney
# Readme
an attempt at learning nix

the end goal is to have a 'one click install' for any given machine



# todo

- [ ] file with configuration variables that can be used in other files
- [ ] set up home manager
- [ ] set up flakes
- [ ] set up flakes.lock
- [ ] the final goal is to have a one line install that works on WSL and standalone
- [ ] `nixos-rebuild switch --flake .#nixos` for WSL
- [ ] `nixos-rebuild switch --flake .#nixos` for bare metal
- [ ] `nixos-rebuild switch --flake .#nixos` for arm
- [ ] install script
- [ ] upgrade script
- [ ] update script
- [ ] clear nix store cache script


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

# Notes
When dual booting this can be used to make windows use UTC time insead of local time to avoid having to sync time when booting into windows from linux, run this in cmd as an admin

```reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f```

# Resources
[WSL](https://github.com/nix-community/NixOS-WSL)

[official website](https://nixos.org/)

[extranix](https://extranix.com/)

[MyNixOS](https://mynixos.com/)
