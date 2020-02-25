# macOS Install

## Add a new ssh key

Generate new key.
```sh
$ ssh-keygen -t rsa -b 4096
```
Copy public key to clipboard, ready to paste into GitHub.
```sh
$ pbcopy < ~/.ssh/id_rsa.pub
```

## Save ssh key password to keychain

Start the ssh-agent in the background.
```sh
$ eval "$(ssh-agent -s)"
> Agent pid 59566
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
$ ssh-add -K ~/.ssh/id_rsa
```


## Bootstrap dependencies

Clone repo and run bootstrap script.
```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles_bare/ --work-tree=$HOME' && \
git clone --bare git@github.com:rus64/dotfiles.git $HOME/.dotfiles_bare && \
dotfiles checkout && \
sh ~/.dotfiles/bootstrap.sh
```

## Other packages

### App Store
* [Xcode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12)
* [Magnet](https://apps.apple.com/gb/app/magnet/id441258766?mt=12)
* [NordVPN](https://apps.apple.com/gb/app/nordvpn-ike-unlimited-vpn/id1116599239?mt=12)
* [JIRA](https://apps.apple.com/gb/app/jira-cloud-by-atlassian/id1475897096?mt=12)

### Sublime
* [Dotfiles Syntax Highlighting](https://packagecontrol.io/packages/Dotfiles%20Syntax%20Highlighting)
* [Swift syntax](https://packagecontrol.io/packages/Swift)

### VS Code
* [API Elements Extension](https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements)
* [Scala Metals](https://marketplace.visualstudio.com/items?itemName=scalameta.metals)
* [Scala syntax](https://marketplace.visualstudio.com/items?itemName=scala-lang.scala)

## Resources
* [Apple Software downloads](https://developer.apple.com/download/release/)
* [ssh key](https://help.github.com/en/articles/working-with-ssh-key-passphrases)
* [dotfiles](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
* [brew](https://brew.sh)
* [zsh-users](https://github.com/zsh-users)

