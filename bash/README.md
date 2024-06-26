# Bash Utilities

Almost everything in this repository is a bash utility.
Here's a couple of quick reminders about Bash.

## Types of bash shells

**Login shell** 
> The first process that executes under our user ID when we log in to a session. The login process tells the shell to behave as a login shell with a convention: passing argument 0, which is normally the name of the shell executable, with a "-" character prepended.

Check: `shopt login_shell` (for BASH only)

**Interactive shell**
> Reads commands from user input on a tty. Among other things, such a shell reads startup files on activation, displays a prompt, and enables job control by default. The user can interact with the shell. A shell running a script is always a non-interactive shell.

Check: `[[ $- == *i* ]] && echo "Interactive" || echo "Non-interactive"`

How do you access the different shell types?

|               | interactive                | non-interactive                    |
|---------------|----------------------------|------------------------------------|
| **login**     | tty (Ctrl + Alt + F1), ssh | Rare (see note below)              |
| **non-login** | Open a new terminal        | Shell scripts, `./script.sh`       |

Non-interactive login shells are rare. For example, you can run `script.sh` in a non-interactive login shell using 
`bash -l -c 'source script.sh'`. `bash -l` opens a bash login shell and `-c 'source script.sh'` runs the command in that shell
non-interactively and exits the shell. 

See discussion at [AskUbuntu](https://askubuntu.com/questions/879364).


## Loading configuration files

For details see the [Documentation](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Bash-Startup-Files). 
Here is a quick summary of initialization in bash:

#### Interactive login shell, or non-interactive shell with `--login`

- Read and execute commands from `/etc/profile`
- Look for `~/.bash_profile`, `~/.bash_login` and `~/.profile` in that order, read and execute from the first one that exists and is readable. Use `--noprofile` to inhibit this behavior.

On exit, reads and executes commands from `~/.bash_logout`, if it exists. 

#### Interactive non-login shell

- Read and execute commands from `~/.bashrc`, if that file exists. Use `--norc` to inhibit, or use `--rcfile filename` to force reading `filename` instead.

#### Non-interactive non-login

- search and execute `$BASH_ENV`, as if running `if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi`
but the value of the `PATH` variable is not used to search for the filename.

#### Invoked with name `sh`

Avoid using. Bash tries to mimic the historical `sh` as close as possible while conforming to POSIX standards.

- For interactive login shell, or non-interactive shell with the `--login option`, read and execute `/etc/profile` and `~/.profile`, in that order. Use `--noprofile` to inhibit.
- For interactive shell, read from file defined in `ENV`, as if running `if [ -n "$ENV" ]; then . "$ENV"; fi`. Warning: `--rcfile` option has no effect
- For non-interactive shell, do not read any other startup files.

#### POSIX mode

Invoked via `--posix`. Read from file defined in `ENV`, as if running `if [ -n "$ENV" ]; then . "$ENV"; fi`. No other startup files are read. 

#### Remote shell daemon

Invoked by the remote shell daemon, usually `rshd`, or the secure shell daemon `sshd`.
- Read and execute from `~/.bashrc`, if that file exists and is readable. Use `--norc` to inhibit, or use `--rcfile filename` to force reading `filename` instead.

Note, however, neither `rshd` nor `sshd` generally invoke the shell with `--norc` / `--rcfile` or allow them to be specified.


![Bash startup file loading decision](../images/bash_startup_decision.png?raw=true "Bash startup file loading decision")

## How to load bashrc in non-interactive non-login shell on a remote server?

Set `BASH_ENV` to point to your `.bashrc`. That’s it!
In `~/.bash_profile` (or `~/.bash_login` or `~/.profile`, whichever is executed during login), set
```
export BASH_ENV="${HOME}/.bashrc"
```

## Quirks
- `bash --norc` loads the environment variables already in the session.
- `${VAR-foo}`  equals `foo` if `VAR` is unset. (remains empty if empty)
- `${VAR:-foo}` equals `foo` if `VAR` is unset or empty.
- `${VAR+foo}`  equals `foo` if `VAR` is set. 
- `${VAR:+foo}` equals `foo` if `VAR` is set and non-empty.
- [How to determine if a bash variable is empty?](https://serverfault.com/questions/7503)

## My home environment

Important: I use [Environment Modules](http://modules.sourceforge.net/), which sets `ENV` and `BASH_ENV`.

I have 3 main files which are loaded in the following sequence from `~/.bashrc` depending on shell type: 
- `common.bashrc` : load always for all sessions.
- `login.bashrc`: load only for login sessions.
- `interactive.bashrc`: load only for interactive sessions, e.g. PS1, bash completion, etc.

Which files are read?
- interactive login : reads `/etc/profile` and `~/.profile` (`~/.bash_profile` and `~/.bash_login` do not exist). Include `~/.bashrc` from `~/.profile`.
- interactive non-login (desktop, laptop) : reads `/etc/bash.bashrc` and `~/.bashrc`.
- non-interactive login :  reads `/etc/profile` and `~/.bashrc`.
- non-interactive non-login : reads `$BASH_ENV`, which is set by `environment modules` to `/opt/environment-modules/init/bash`. Source `~/.bashrc` separately.

## Ubuntu `/etc/profile`
- read and execute `/etc/bash.bashrc`, if it exists.
- read and execute all files in `/etc/profile.d`, if they exist.
