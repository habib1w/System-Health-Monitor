#Linux system Health Monitoring tool

#Overview
A Bash script that monitors the health of a Linux system by checking:
- Disk usage
- Memory utilisation
- NGINX service status

#Technologies used
- Bash
- Linux (ubuntu)
- SSH
- Git
- NGINX

#What I learned
- Bash scripting
- Linux command line
- Service management with systemctl
- Troubleshooting

## Example Output

Running locally on MacOS (local test)- some checks are Linux only and wont run natively on Mac

![Local run on macOS](screenshots/mac-local-output.png)

Running on Ubuntu (AWS EC2) — full check, as intended:

![Full run on EC2](screenshots/ec2-output.png)
