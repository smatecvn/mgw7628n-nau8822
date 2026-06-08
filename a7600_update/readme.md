# A7600 Firmware Upgrade Guide

## Prerequisites

- Ensure the device has an active Internet connection.
- Ensure the target firmware version is available on the firmware repository.
- Do not power off the device during the upgrade process.

## Upgrade Procedure

### Step 1: Download the upgrade script

Copy the script `update_a7600.sh` to the following directory:

```bash
/mnt/mmcblk0p1
```

### Step 2: Change to the script directory

```bash
cd /mnt/mmcblk0p1
```

### Step 3: Make the script executable

```bash
chmod +x update_a7600.sh
```

### Step 4: Run the firmware upgrade

Syntax:

```bash
./update_a7600.sh -v <FW_VERSION>
```

Example:

```bash
./update_a7600.sh -v A50C4B14A7600M7
```

## Upgrade Process

The script will automatically:

1. Stop related services and processes.
2. Download the firmware package from the repository.
3. Download the firmware downloader utility if not already present.
4. Upgrade the A7600 firmware.
5. Verify the upgrade result.
6. Reboot the A7600 module.
7. Restart system services.

## Successful Upgrade

If the upgrade is successful, the following message will be displayed:

```text
Firmware upgrade SUCCESS
```

The A7600 module will then be restarted automatically.

## Failed Upgrade

If the upgrade fails, the following message will be displayed:

```text
Firmware upgrade FAILED
```

Check the upgrade log for troubleshooting:

```bash
cat /tmp/a7600_upgrade.log
```

## Notes

- Do not interrupt the upgrade process.
- Do not power off the device while firmware is being written.
- The upgrade may take several minutes depending on firmware size and module response time.