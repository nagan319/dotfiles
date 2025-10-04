# ~/.config/fish/functions/fish_prompt.fish

function fish_prompt
    # Print the current working directory. The '~' (tilde) is used for $HOME.
    # '%c' prints the current directory name only, while '%/' prints the full path.
    # Using a single color makes the prompt cleaner.

    # 1. Print the directory in a shade of white/gray
    set_color normal
    echo -n (prompt_pwd)

    # 2. Add the prompt symbol (e.g., '❯' or '$')
    set_color white
    echo -n '❯ '
end
