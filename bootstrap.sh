#!/bin/bash
# --- --- ---
# Setup for sec configs, might expand into a singular setup script for all dotfiles

chmod 600 ~/.ssh/config # readable and writable only by the user
chmod 600 ~/.ssh/id_rsa # readable and writable only by the user
chmod 644 ~/.ssh/id_rsa.pub # readable by everyone, writable only by the user
chmod 644 ~/.ssh/known_hosts # readable by everyone, writable only by the user
chmod 644 ~/.ssh/authorized_keys # readable by everyone, writable only by the user

# --- --- ---

# Setup for bashrc
for file in ~/.bashrc ~/.bash_aliases ~/.bash_profile ~/.bash_prompt; do
    if [ -f $file ]; then
        mv $file $file.bak
    fi
        touch $file
done

# Run from the root of the dotfiles repo
cp ./shell/.bashrc ~/.config/.bashrc
cp ./shell/.bash_aliases ~/.config/.bash_aliases
cp ./shell/.bash_profile ~/.config/.bash_profile
cp ./shell/.bash_prompt ~/.config/.bash_prompt
source ~/.bashrc