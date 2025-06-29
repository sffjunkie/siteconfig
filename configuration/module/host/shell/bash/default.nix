# bash is now always available so we don't need to make this conditional
{
  config = {
    programs.bash.promptInit = ''
      # Augment nixpkgs bash prompt to change color when using SSH
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        if [ -n "$SSH_CONNECTION" ]; then
          PROMPT_COLOR="1;33m"
        else
          PROMPT_COLOR="1;31m"
          ((UID)) && PROMPT_COLOR="1;32m"
        fi
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };
}
