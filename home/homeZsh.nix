{ userName,  ... }:

{
  programs.atuin = { enable = false; enableZshIntegration = true; daemon.enable = true; forceOverwriteSettings = false; };
  programs.hstr  = { enable = false; enableZshIntegration = true; }; # ctrl + r
  programs.zsh = {
    enable = true;
    history = { # https://zsh.sourceforge.io/Doc/Release/Options.html
      append         = true;
      save           = 10000;
      size           = 10000;
      share          = true;
      extended       = true;
      findNoDups     = true;
      ignoreDups     = true;
      saveNoDups     = true;
      ignoreSpace    = true;
      ignoreAllDups  = true;
      ignorePatterns = [ ];
    };
    enableCompletion    = true;
    oh-my-zsh= { enable = true; theme = "rkj-repos"; plugins = [ "git" "z" "sudo" ]; }; # duellj darkblood fino-time bira gnzh jonathan rkj-repos
    # zsh-abbr.enable = true;
    # syntaxHighlighting.enable = true;
    fastSyntaxHighlighting.enable = true;
    autosuggestion = {
      enable       = true;
      highlight    = "fg=#878787,bold,underline"; # ,bg=cyan,
      strategy     = [ "match_prev_cmd" "history" "completion" ];
    };
    # shellAliases = { };
    # shellGlobalAliases = { };
    localVariables = { ZSH_AUTOSUGGEST_BUFFER_MIN_SIZE = "1"; };
    # sessionVariables = { EDITOR = "nvim"; };
    initContent = ''
      function _hist_hold() {
        LASTHIST=''${1%%$'\n'}
        return 1   # don't save yet; the line stays available for up-arrow until the next command
      }
      function _hist_keep_if_ok() {
        local ret=$?
        if [[ $ret -eq 0 && -n $LASTHIST ]]; then
          print -sr -- "$LASTHIST"
        fi
        unset LASTHIST
      }
      autoload -Uz add-zsh-hook
      add-zsh-hook zshaddhistory _hist_hold
      add-zsh-hook precmd _hist_keep_if_ok
      # bindkey -r "^[[A"     # Disables Alt+Up
      # bindkey -r "^[[B"     # Disables Alt+Down
      # bindkey -r "^[[C"     # Disables Alt+Right
      # bindkey -r "^[[D"     # Disables Alt+Left
      bindkey -r "^[[1;3A"  # Disables Alt+Up    in graphical sessions
      bindkey -r "^[[1;3B"  # Disables Alt+Down  in graphical sessions
      bindkey -r "^[[1;3C"  # Disables Alt+Right in graphical sessions
      bindkey -r "^[[1;3D"  # Disables Alt+Left  in graphical sessions
      zstyle ':completion:*' menu select
      # unsetopt listambiguous
      setopt menu_complete                  # first Tab enters the menu immediately
      zstyle ':completion:*' menu select
      # zstyle ':completion:*' list-prompt    # scroll in the menu instead of asking "see all
    '';
  };
}
