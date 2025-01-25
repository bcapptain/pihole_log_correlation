# PiHole Domain Block Correlation Logging

A script that correlates "query" and "blocked" log lines from the Pi-hole log by adding the client IP from the "query" line to the "blocked" line and outputs it to a separate log file.

## Files

- `correlate_blockings.py`: The Python script that monitors the PiHole log file and logs domain block correlations.
- `correlate_blockings.service`: The systemd service file to run the script automatically on startup.

## Installation

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/yourusername/pihole-domain-block-correlation.git
    cd pihole-domain-block-correlation
    ```

2. **Copy the Script and Service File**:
    ```sh
    sudo cp correlate_blockings.py /opt/pihole/
    sudo cp correlate_blockings.service /etc/systemd/system/
    ```

3. **Set Permissions**:
    ```sh
    sudo chmod +x /opt/pihole/correlate_blockings.py
    ```

4. **Reload Systemd**:
    ```sh
    sudo systemctl daemon-reload
    ```

5. **Enable and Start the Service**:
    ```sh
    sudo systemctl enable correlate_blockings.service
    sudo systemctl start correlate_blockings.service
    ```

6. **Check the Service Status**:
    ```sh
    sudo systemctl status correlate_blockings.service
    ```

## Usage

The script will automatically start on boot and monitor the PiHole log file located at `/opt/pihole/log-pihole/pihole.log`. It will log domain block correlations to `/opt/pihole/log-pihole/blockings.log`.

### Customization

You may need to adjust the script location, input file name, and output file name within the script to meet your individual environment. Modify the following variables in `correlate_blockings.py` as needed:
- `logfile_path`: Path to the PiHole log file.
- `output_file_path`: Path to the output log file.

## Contributing

Feel free to submit issues or pull requests if you have any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

