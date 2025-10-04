### DNF Packages

These are just the user-end packages, I'm assuming things like audio and wifi drivers are installed:

```bash
sudo dnf update
sudo dnf install sway swaylock waybar wofi
sudo dnf install fish foot nvim tmux
sudo dnf install ranger htop
sudo dnf install zathura pandoc texlive-scheme-full
```

### Flatpak Packages
    
``` bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.mozilla.librewolf io.gitlab.librewolf-community 
flatpak install flathub com.google.Chrome                 
flatpak install flathub md.obsidian     
```

### Dotfiles

Clone this repository into the user space:

```bash
git clone ... /home/<username>/
```

The repo contains the following structure:

```
Downloads/
    .gitkeep
.config/
    fish/
        completions/
        conf.d/
        config.fish
        fish_variables
        functions/
            fish_prompt.fish
    foot/
        foot.ini 
    nvim/
        init.lua
        lazy-lock.json
    sway/
        config 
    swaylock/
        config
    waybar/
        config
        style.css
    wofi/
        style.css
    zathura/
        zathurarc
.tmux.conf 
README.md
```

### NerdFont Installation

Go to the NerdFont website and select the Meslo font: 
https://www.nerdfonts.com/font-downloads

```bash
mkdir -p ~/.local/share/fonts
unzip -d ~/.local/share/fonts/ ~/Downloads/Meslo.zip
fc-cache -fv
rm ~/Downloads/Meslo.zip
```

### Browser Setup

**Librewolf (Personal)**

Use dark mode. 
Install Bitwarden addon and log in with personal account.
Install Firefox Container addon and create containers for Meta, Amazon, Google and banks.
Set exceptions to store Google cookies, avoid having to do 2FA every time.

**Chrome (Academic)**

Use dark mode.
Install Bitwarden addon and log in with academic account.

### New Academic Vault

Write once vault program is done.

### Academic Vault Re-Sync

Write once vault program is done.
    
