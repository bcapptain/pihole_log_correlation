#!/bin/python3

import time
import re
import os
import stat

def get_file_size(filepath):
    try:
        return os.stat(filepath).st_size
    except OSError:
        return 0

def follow(file, filepath):
    file.seek(0, 2)  # Move to the end of the file
    last_size = get_file_size(filepath)
    
    while True:
        try:
            line = file.readline()
            if not line:
                # Check if file has been rotated
                current_size = get_file_size(filepath)
                if current_size < last_size:
                    print(f"Log file {filepath} has been rotated, reopening...")
                    return None
                last_size = current_size
                time.sleep(0.1)  # Sleep briefly
                continue
            yield line
        except Exception as e:
            print(f"Error reading log file: {e}")
            return None

logfile_path = '/opt/pihole/log-pihole/pihole.log'
output_file_path = '/opt/pihole/log-pihole/blockings.log'
search_strings = ['query', 'blocked']

while True:
    try:
        # Extract domains and IPs from query lines
        query_dict = {}

        with open(logfile_path, 'r') as logfile, open(output_file_path, 'a', buffering=1) as output_file:
            loglines = follow(logfile, logfile_path)
            if loglines is None:
                continue
                
            for line in loglines:
                if line is None:
                    break
                    
                if 'query' in line or 'blocked' in line:
                    match_query = re.search(r'query\[[A-Z]+\] ([\w.-]+) from ([\d.]+)', line)
                    if match_query:
                        domain = match_query.group(1)
                        ip_address = match_query.group(2)
                        query_dict[domain] = ip_address

                    match_blocked = re.search(r'blocked ([\w.-]+) is', line)
                    if match_blocked:
                        domain = match_blocked.group(1)
                        if domain in query_dict:
                            ip_address = query_dict[domain]
                            updated_line = f"{line.strip()} (from {ip_address})"
                            print(updated_line)
                            output_file.write(updated_line + '\n')
                        else:
                            print(line, end='')
                            output_file.write(line)
                else:
                    continue
    except Exception as e:
        print(f"Error in main loop: {e}")
        time.sleep(1)  # Wait a bit before retrying
        continue
