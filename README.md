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
  ```

  3. Create the SSH keys. For example,
  ```
  cd .ssh
  ssh-keygen -t ed25519 -f github_key
  ```

# References

- [dotfiles](https://dotfiles.github.io/)
- [random-toolbox](https://github.com/johnlane/random-toolbox)
