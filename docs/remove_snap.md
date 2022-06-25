# Remove Snap from Ubuntu

Last Updated: 2022-06-25

1. List all the snaps installed on the system:

```
snap list
```

2. Remove each snap that you may have chosen to install using `sudo snap remove <package>`.
It’s best to do so one-by-one, rather than all in one apt remove line. So something like:

```
sudo snap remove chromium
sudo snap remove emote
sudo snap remove spotify
sudo snap remove vlc
```

3. Remove the core snaps in this order (your list may be slightly different):

```
sudo snap remove snap-store
sudo snap remove gtk-common-themes
sudo snap remove gnome-system-monitor
sudo snap remove gnome-3-34-1804
sudo snap remove gnome-3-28-1804
sudo snap remove core18
sudo snap remove snapd
```

4. Verify there are no more snaps installed with `snap list`. You should see a message like this:

```
No snaps are installed yet. Try 'snap install hello-world'.
```

5. Unmount the snap mount points with sudo umount `/snap/core/{point}`, replacing `{point}` with the actual mount point. You can find the complete list using df -h.

Note: In Ubuntu 20.10 (and newer) you only need to do this: `sudo umount /var/snap`.


6. Stop snapd (snap daemon) services:

```
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
```

7. Purge or remove completely snapd using the following command:

```
sudo apt purge snapd
sudo apt autoremove --purge snapd
```

8. Using purge doesn’t touch the home directory, so optionally delete any files previously created in `~/snap`:

```
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd/
```

## References
- [AskUbuntu: How do I remove all snaps and snapd, preferably with a single command](https://askubuntu.com/questions/1309144)
- [Remove Snap Ubuntu 22.04 LTS](https://haydenjames.io/remove-snap-ubuntu-22-04-lts/)
