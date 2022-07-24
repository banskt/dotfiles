# Crontab schedule

Write crontab entries using:
```
sudo crontab -e
```
Access crontab of `username`:
```
sudo crontab -u username -e
```

The default crontab entry begins with 5 stars followed by a command, which will run once a minute. You can change these to suit your exact schedule by minute, hour, day of month, month, and day of week.

```
.------------ minute (0-59) (* = every minute)
| .---------- hour (0-23) (* = every hour)
| | .-------- day of month (1-31) (* = every day)
| | | .------ month (1-12 or jan-dec) (* = every month)
| | | | .---- day of week (0-6 or mon-sun) (Sunday=0) (* = every day)
| | | | |
* * * * * command_to_run
```

Examples:

```
30 23 * * *       Every day at 11.30pm
0 0 * * *         Every day at midnight (00:00)
*/10 * * * *      Every 10 mins
0 */12 * * *      Every 12 hours
0 17 * * sun      Every Sunday at 5pm
0 17 * * sun,mon  Every Sunday and Monday at 5pm
0 5,17 * * *      At 5am and 5pm daily
0 12 1 jan,feb *  At 12pm on the 1st of every Jan and Feb
0 0 1 * *         The 1st day of every month at midnight
```
