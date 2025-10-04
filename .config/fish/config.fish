if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U EDITOR "nvim"
set -U VISUAL "nvim"

fish_vi_key_bindings
bind -M default \cl accept-autosuggestion
bind -M insert \cl accept-autosuggestion
