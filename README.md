# nixjourney
# Readme
an attempt at learning nix

the end goal is to have a 'one click install' for any given machine



# todo

<!--
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

- [ ] script rework, test script (dry-activate), upgrade after boot (updates flake lock), update after boot

configuration structure
core files:
flake.nix, configuration.nix, homemanager.nix
all of the above files are passed to every configuration
each configuration then has its own moduleConfig1 and homeConfig1 files that may branch out into smaller more specific files

one idea I have for user defined variables is to make an install script that asks what the variable should be and it gets passed to the nix system, username or localisation would be a good example, user no longer has to go into the config all he has to do is call an install script and choose the right variables, kind of like archinstall
list of things the user has to define:
username, hostname, localisation, keymap
list of things that are automatically defined based on available information:
cpu architecture, gpu vendor
-->

# Notes
When dual booting this can be used to make windows use UTC time insead of local time to avoid having to sync time when booting into windows from linux, run this in cmd as an admin

```reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f```

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
