Here are the improved directions with better formatting in markdown:

# MPSS (Mount Point Service Sync)
=====================================

MPSS dynamically controls start/stop of services (plexmediaserver, tdarr_node, Tdarr_Uptime, emby-server) based on presence or absence of "MOUNT_POINT_ALIVE" file on a network share. It logs actions to /var/log/mpss.log and trims the log to 200 lines.

## Usage Example
----------------

I run several services in my linux environment that depend on data on a network share to function. Occasionally that share goes offline for some reason. This script was written to ensure those services are shut down when the mount point becomes unavailable.

### Basic Concept
---------------

1. Crontab that runs this script regularly
2. Script checks for a file on the network share
	* If it does, ensure the service is running
	* If it does not, ensure the service is stopped

## Setup
--------

### Step 1: Download the Script
------------------------------

Download the script from this git repository:

```bash
mkdir /opt/mpss
git clone https://github.com/tebwritescode/mpss.git
cp ./mpss/mpss.sh /opt/mpss/mpss.sh
```

### Step 2: Customize the Script
-------------------------------

Customize the script by modifying the variables at the top of the file:

```bash
nano /opt/mpss/mpss.sh
```

Modify `FILE`, `SERVICE`, `LOG_FILE`, and `MAX_LINES` to match your setup.

Example:
```bash
FILE="/path/to/mount/MOUNT_POINT_ALIVE" #The location of the file on the share
SERVICE="plexmediaserver" #Service that can be started/stopped with systemctl
LOG_FILE="/var/log/mpss.log" #Where to save the log
MAX_LINES=200 #How many lines of logs to keep in the log file
```

Save your changes with <kbd>ctrl</kbd> + <kbd>x</kbd>, then <kbd>y</kbd>, then <kbd>return</kbd>.

### Step 3: Create the Log File
---------------------------

Create the log file:

```bash
touch /var/log/mpss.log
```

### Step 4: Create the Check File
------------------------------

Create the check file on the network share:

```bash
touch /path/to/mount/MOUNT_POINT_ALIVE
```

### Step 5: Make the Script Executable
------------------------------------

Make the script executable:

```bash
chmod +x /opt/mpss/mpss.sh
```

### Step 6: Schedule the Script with Crontab
-----------------------------------------

Schedule the script to run regularly using crontab. Add the following line to your crontab file (use `crontab -e` to edit):

```bash
*/1 * * * * /opt/mpss/mpss.sh
```

Note: Be aware that some versions of cron do not support all times you can create on crontab.guru, you will get an error when saving the file.

That's it! Your MPSS script should now be set up to automatically start/stop services based on the presence or absence of the `MOUNT_POINT_ALIVE` file on your network share.
