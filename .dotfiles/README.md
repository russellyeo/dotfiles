# Fresh macOS Install

Set up a new macOS machine with my dotfiles and essential software to recreate my dev environment.

## Install Xcode command line tools
```sh
xcode-select --install
```

## Add a new ssh key
Generate a new ssh key.
```sh
ssh-keygen -t rsa -b 4096
```

Copy public key to clipboard, then paste into [GitHub SSH keys](https://github.com/settings/keys). Delete old keys if needed.
```sh
pbcopy < ~/.ssh/id_rsa.pub
```

## Save ssh key password to keychain
Start the ssh-agent in the background.
```sh
eval "$(ssh-agent -s)"
```

Modify ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in the keychain.
```sh
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
```

Add your SSH private key to the ssh-agent and store your passphrase in the keychain.
```sh
ssh-add -K ~/.ssh/id_rsa
```

## Bootstrap
Set up system dotfiles and run a script to download tools, packages and applications.

1. Temporarily define the alias in the current shell scope
```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles_bare/ --work-tree=$HOME'
```

2. Clone dotfiles bare repository into the home directory
```sh
git clone --bare git@github.com:rus64/dotfiles.git $HOME/.dotfiles_bare
```

3. Checkout the content from the bare repository
```sh
dotfiles checkout
```

4. Run the bootstrap script
```sh
sh ~/.dotfiles/bootstrap.sh
```

## Configure

### Set up iTerm
In `Preferences > General > Preferences` select "Load preferences from a custom folder or URL" and set it to `~/.dotfiles/iTerm2/`.

### Xcode
Download and install Xcode from [Apple](https://developer.apple.com/download/release/) then ensure the correct Command Line Tools are set

```sh
sudo xcode-select -p
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

Once Xcode has been installed at least once, use xcodes to manage updates

```sh
brew install robotsandpencils/made/xcodes
xcodes update
xcodes list
```

### Set up VS Code to launch from the command line with `code` command
* Launch VS Code.
* Open the Command Palette (`Cmd+Shift+P`) and type 'shell command' to find the Shell Command: Install 'code' command in PATH command.

Source: [Launching from the command line](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line)

## More downloads
Other software not automated in the above bootstrap script.

### App Store
* [1Password](https://apps.apple.com/gb/app/1password-7-password-manager/id1333542190?mt=12)
* [Magnet](https://apps.apple.com/gb/app/magnet/id441258766?mt=12)

### Direct downloads
* [Sublime Merge](https://www.sublimemerge.com/download)

### Sublime
* [Dotfiles Syntax Highlighting](https://packagecontrol.io/packages/Dotfiles%20Syntax%20Highlighting)
* [Swift syntax](https://packagecontrol.io/packages/Swift)

### VS Code
* [API Elements Extension](https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements)
* [Scala Metals](https://marketplace.visualstudio.com/items?itemName=scalameta.metals)
* [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)

## Resources
* [Working with SSH key passphrases](https://help.github.com/en/articles/working-with-ssh-key-passphrases)
* [The best way to store your dotfiles: A bare Git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
* [Homebrew](https://brew.sh)
* [zsh-users](https://github.com/zsh-users)
* [Apple software downloads](https://developer.apple.com/download/release/)
* [macOS defaults](https://macos-defaults.com/)