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
git clone --bare git@github.com:russellyeo/dotfiles.git $HOME/.dotfiles_bare
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

## More downloads

Other software not automated in the above bootstrap script.

### App Store

* [RocketSim](https://www.rocketsim.app/)

## Resources

* [Working with SSH key passphrases](https://help.github.com/en/articles/working-with-ssh-key-passphrases)
* [The best way to store your dotfiles: A bare Git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
* [Homebrew](https://brew.sh)
* [zsh-users](https://github.com/zsh-users)
* [Apple software downloads](https://developer.apple.com/download/release/)
* [macOS defaults](https://macos-defaults.com/)