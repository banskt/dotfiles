# dotfiles

My collection of dotfiles. I do not have a bootstrap yet, installation is hard-coded.

## How to install

  1. Clone the repository.
  ```
  git clone https://github.com/banskt/dotfiles.git .dotfiles
  ```

  2. Run the `install` script.
  ```
  source .dotfiles/install
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/config
  ```

  3. Create the SSH keys. For example,
  ```
  cd .ssh
  ssh-keygen -t ed25519 -f github_key
  ```

  4. Setup GitHub connection (edit gitconfig to enter email).
  ```
  cd
  cp .dotfiles/git/gitconfig .gitconfig
  ```
  This could have been included in the `install` script,
  but I do not want to keep my email in the public domain. 
  ```
  git remote set-url origin git@github.com:banskt/dotfiles.git
  ```
  Check if git remote is correct.
  ```
  git remote show origin
  ```

# References

- [dotfiles](https://dotfiles.github.io/)
- [random-toolbox](https://github.com/johnlane/random-toolbox)
