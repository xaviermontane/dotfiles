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
cp ./shell/.bashrc ~/.bashrc