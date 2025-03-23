# PiHole Block Correlation

This script correlates PiHole query logs with blocked domain entries to show which IP addresses triggered the blocks.

## Features

- Real-time correlation of PiHole query and block logs
- Shows IP addresses that triggered blocked domains
- Handles log rotation automatically
- Works with both native PiHole installations and Docker containers
- Runs as a systemd service

## Installation

### Using the Installation Script (Recommended)

1. Clone this repository or download the files:
   - `correlate_blockings.py`
   - `correlate_blockings.service`
   - `install.sh`

2. Make the installation script executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the installation script as root:
   ```bash
   sudo ./install.sh
   ```

4. The script will:
   - Check for PiHole installation (native or Docker)
   - Ask for installation path (default: `/opt/pihole/correlate_blockings.py`)
   - Set up the systemd service
   - Start the service automatically

### Manual Installation

1. Copy the Python script to your desired location:
   ```bash
   sudo cp correlate_blockings.py /opt/pihole/
   sudo chmod +x /opt/pihole/correlate_blockings.py
   ```

2. Copy the service file:
   ```bash
   sudo cp correlate_blockings.service /etc/systemd/system/
   ```

3. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable correlate_blockings.service
   sudo systemctl start correlate_blockings.service
   ```

## Usage

The script runs automatically as a service and writes correlated logs to `/opt/pihole/log-pihole/blockings.log`.

To check the service status:
```bash
sudo systemctl status correlate_blockings.service
```

To view the logs:
```bash
tail -f /opt/pihole/log-pihole/blockings.log
```

## Requirements

- Python 3
- PiHole (native installation or Docker container)
- systemd-based Linux system
- Root privileges for installation

## Troubleshooting

If the service fails to start:
1. Check the service status: `sudo systemctl status correlate_blockings.service`
2. Check the logs: `journalctl -u correlate_blockings.service`
3. Verify PiHole is running and accessible
4. Ensure the log directory exists and has proper permissions

## License

This project is licensed under the MIT License. See the LICENSE file for details.

