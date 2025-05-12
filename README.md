# Updating assets

## catppuccin iterm

https://github.com/catppuccin/iterm?tab=readme-ov-file

## iterm2-profile.json

From iTerm, go to ```Settings -> Profile -> Other Actions -> Save Profile as JSON...```

# Configuration

## homebrew

https://brew.sh/

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## iTerm

```bash
brew install --cask iterm2
brew install --cask font-jetbrains-mono
brew install --cask font-hack-nerd-font
```

Import iterm2 profile from ```assets/iterm2-profile.json```

## rust

https://www.rust-lang.org/tools/install

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## nvim

```bash
brew install nvim coreutils rg pyenv pyenv-virtualenv tree-sitter
```

```bash
echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
```

```bash
pyenv install 3
pyenv virtualenv 3 py3nvim
```

```bash
pyenv activate py3nvim
python3 -m pip install pynvim
pyenv which python # Add the path to init.lua
```
