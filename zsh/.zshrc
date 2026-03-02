# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path variables
export PATH="/opt/homebrew/bin:$PATH"


# Source Antidote
source ~/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load


# Software stuff
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bryan/Repos/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/bryan/Repos/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/bryan/Repos/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/bryan/Repos/google-cloud-sdk/completion.zsh.inc'; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Setup zoxide
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set matplotlib config directory to prevent warnings
export MPLCONFIGDIR="$HOME/.matplotlib"

export GPG_TTY=$(tty)
export PATH="$HOME/.local/bin:$PATH"

alias vim='nvim'
