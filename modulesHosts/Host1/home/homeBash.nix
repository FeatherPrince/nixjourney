{ userName,  ... }:

{
  programs.atuin = { enable = false; enableBashIntegration = true; daemon.enable = true; forceOverwriteSettings = false; };
  programs.hstr  = { enable = false; enableBashIntegration = true; }; # ctrl + r
  programs.bash  = {
    enable = true;
    # bashrcExtra commands executed in non all shells including non interactive ones
    # bashrcExtra = "";
    shellAliases = { };
    # initExtra commands executed in interactive shells
    initExtra =
    "
    bind 'set completion-ignore-case on'
    HISTCONTROL=erasedups:ignorespace # ignoredups ignoreboth
    shopt -s histappend
    PROMPT_COMMAND=\"history -a; history -n; $PROMPT_COMMAND\"
    HISTIGNORE=\"ls:ls *:ll:ll *:cd:cd *:pwd:pwd *:history:history *:clear:clear *:exit:exit *\"
    HISTSIZE=10000
    HISTFILESIZE=10000000
    ";
  };
}
