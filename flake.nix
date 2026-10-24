{
  description = "A very basic flake";

  inputs = {
    nixpkgs      = { url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
    sops-nix     = { url = "github:Mic92/sops-nix";             inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixvim       = { url = "github:nix-community/nixvim";       inputs.nixpkgs.follows = "nixpkgs"; };
    ollama-src   = { url = "github:ollama/ollama/v0.40.9"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ollama-src, ... }:
  let
    hostName     = "nest";
    userName     = "feather";
    stateVersion = "26.05";

    # Build a NixOS system. Everything that is shared lives here; callers
    # only supply the bits that actually differ between hosts.
    mkHost = { stateVersion ? [], homeStateVersion ? [], hardwareModule ? [], systemModules ? [], homeModules ? [] }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit stateVersion userName hostName; };
        modules = [
          sops-nix.nixosModules.sops
          {
            nixpkgs.overlays = [
              (final: prev: {
                mozc = prev.mozc.overrideAttrs (old: {
                  postPatch = (old.postPatch or "") + ''
                    substituteInPlace src/gui/dictionary_tool/dictionary_tool.ui \
                      --replace-fail '::mozc::gui::DictionaryContentTableWidget' 'mozc::gui::DictionaryContentTableWidget'
                  '';
                });
              })
              (final: prev:
              let
                # llama.cpp tag that this Ollama release pins, read from its own source
                llamaCppTag = prev.lib.removeSuffix "\n"
                  (builtins.readFile "${ollama-src}/LLAMA_CPP_VERSION");
              in {
                ollama-vulkan = prev.ollama-vulkan.overrideAttrs (old: {
                  version = "0.40.9";
                  src = ollama-src;
                  vendorHash = "sha256-1mzJrZUHH2ouP6I+LVojHbft7No5AumqKZVq0I/Ubsg="; # final.lib.fakeHash; # replace after the first build
                  # nixpkgs' Go is one patch release behind what upstream's go.mod asks for
                  postPatch = (old.postPatch or "") + ''
                    sed -i -E 's/^go 1\.26\.10$/go 1.26.9/; /^toolchain /d' go.mod
                  '';
                  passthru = (old.passthru or { }) // {
                    llamaCppVersion = llamaCppTag;
                    llamaCppSrc = prev.fetchFromGitHub {
                      owner = "ggml-org";
                      repo = "llama.cpp";
                      tag = llamaCppTag;
                      hash = "sha256-xK7GHR5ywEgrgLAP8DVp+RjOV5065LT7XmpzBDOWf/0=";#final.lib.fakeHash; # replace after the first build
                    };
                  };
                });
              })
            ];
          }
        ]
        ++ systemModules
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs       = true;
              useUserPackages     = true;
              backupFileExtension = "backup";
              extraSpecialArgs    = { inherit userName; };
              users.${userName} = {
                imports = homeModules;
              };
            };
          }
        ];
      };
  in
  {
    nixosConfigurations = {
      # wsl      = mkHost { };
      # host1    = mkHost {
      #   hardwareModule = [];
      #   systemModules  = [];
      #   homeModules    = [];
      # };
      # hyprland = mkHost { systemModules = [ ./Profiles/profileHyprland/moduleHyprland.nix ]; };
      plasma   = mkHost { systemModules = [ ./modulesHosts/Host1/moduleHost1.nix ]; homeModules = [ ./modulesHosts/Host1/homeHost1.nix ]; };
      # noctalia = mkHost { systemModules = [ ./Profiles/profileNoctalia/moduleNoctalia.nix ]; };
      # mangowm  = mkHost { systemModules = [ ./Profiles/profileMangowm/moduleMangowm.nix ]; };
      # niri     = mkHost { systemModules = [ ./Profiles/profileNiri/moduleNiri.nix ]; };

      # gnome = mkHost {
      #   systemModules     = [ ./Profiles/profileGnome/moduleGnome.nix ];
      #   homeModules = [ ./Profiles/profileGnome/homeGnome.nix ];
      # };
    };
  };
}


# TODO
# set userName, hostName, homeStateVersion and systemStateVersion from the flake
# hostName should be the same as the profile name
