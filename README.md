# nixjourney
# Readme
an attempt at learning nix

~~the end goal is to have a 'one click install' for any given machine that 'just works' regardless of the hardware vendor or cpu architecture~~
this is silly on nix, I might add one profile dedicated to this purpose someday

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

# Resources
[WSL](https://github.com/nix-community/NixOS-WSL)

[official website](https://nixos.org/)

[extranix](https://extranix.com/)

[MyNixOS](https://mynixos.com/)

<!--
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
-->

# Architecting the server
connection types
- host   - from host machine
- local  - from LAN
- remote - from WAN
Split horison DNS
Cloudflare tunnel for WAN connectivity
Cloudflare for SSL cert
Kanidm for SSO and OIDC
nginx for reverse proxy

# list of appimage apps
- [rimstack](https://theforgotten69.github.io/RimStack/) - rimworld mod manager
- [hayase](https://hayase.watch/)
- [spotifast](https://spotifast.rocks/)
- [aurora](https://github.com/ppcharcoal/aurora)
- [craft suite](https://getartcraft.com/apps)
  - photocraft
  - vectorcraft
  - filmcraft
  - lightcraft
  - pdfcraft
  - effectcraft
  - designcraft
  - figcraft
  - wordcraft
  - soundcraft
  - deckcraft
  - cadcraft
  - gridcraft
- beyond all reason
- osu
