# Fresh macOS Install

Set up a new macOS machine with my dotfiles and essential software to recreate my dev environment.

## Add a new ssh key

Generate a new ssh key.
```sh
ssh-keygen -t rsa -b 4096
```

Copy public key to clipboard, ready to paste into GitHub or elsewhere.
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

```sh
# Temporarily define the alias in the current shell scope
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles_bare/ --work-tree=$HOME'

# Clone dotfiles bare repository into the home directory
git clone --bare git@github.com:rus64/dotfiles.git $HOME/.dotfiles_bare

# Checkout the content from the bare repository
dotfiles checkout

# Run the bootstrap script
sh ~/.dotfiles/bootstrap.sh
```

## More downloads

Other software not automated in the above bootstrap script.

### App Store
* [Xcode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12)
* [Magnet](https://apps.apple.com/gb/app/magnet/id441258766?mt=12)
* [NordVPN](https://apps.apple.com/gb/app/nordvpn-ike-unlimited-vpn/id1116599239?mt=12)

### Sublime
* [Dotfiles Syntax Highlighting](https://packagecontrol.io/packages/Dotfiles%20Syntax%20Highlighting)
* [Swift syntax](https://packagecontrol.io/packages/Swift)

### VS Code
* [API Elements Extension](https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements)
* [Scala Metals](https://marketplace.visualstudio.com/items?itemName=scalameta.metals)


## Resources
* [Working with SSH key passphrases](https://help.github.com/en/articles/working-with-ssh-key-passphrases)
* [The best way to store your dotfiles: A bare Git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
* [Homebrew](https://brew.sh)
* [zsh-users](https://github.com/zsh-users)
* [Apple software downloads](https://developer.apple.com/download/release/)