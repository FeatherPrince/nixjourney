# nixjourney
# Readme
an attempt at learning nix

the end goal is to have a 'one click install' for any given machine that 'just works' regardless of the hardware vendor or cpu architecture

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

# todo
REWORK THE MENU SCRIPT: change the order of operation, first show several questions
'cancel'
'settings will apply to the current profile if no other profile was selected'
'currently selected profile is: $PROFILE'
	'apply changes and rebuild selected profile'
	'update flake.lock and rebuild selected profile'
	'pull new version from github and rebuild selected profile'
	'change profile'
	'headless'
	'wsl'
	'plasma'
	...
'more options'
	'enable office apps' (libre office, ... )
	'enable creative apps' (gimp, krita, blender, ... )
	'enable local ai' (ollama, opencode, ... )           
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

syllabus
https://openid.net/developers/how-connect-works/
OIDC - OpenID Connect
SSO  - Single Sign-On
LDAP - Lightweight Directory Access Protocol
SSL  - Secure Sockets Layer

arr stack 
  Framerr
  
  https://wiki.servarr.com/
  lidarr
  radarr
  readarr
  sonarr
  whisparr
  prowlarr
  
 	bazarr
	recyclarr
	tdarr
	yarr
hayase extensions
https://raw.githubusercontent.com/anh9000/anitorrent/main/hayase/index.json
https://raw.githubusercontent.com/x7amod/Hayase-Nyaa/main/index.json
https://raw.githubusercontent.com/tanzim2000/hayase-extension/refs/heads/main/index.json
https://exten.pages.dev/index.json
https://exten.pages.dev/dub/index.json
https://exten.pages.dev/hentai/index.json
https://exten.pages.dev/multi/index.json
https://exten.pages.dev/nzb/index.json


obliterate nginx after a rebuild if something is awry
systemctl stop nginx && pkill -f nginx && systemctl start nginx


this is how to tell which packages are going to get upgraded
sudo nixos-rebuild build --impure --flake .#<profile file path/profile>
sudo nixos-rebuild build
nix store diff-closures /var/run/current-system ./result
nvd diff /run/current-system ./result
-->
