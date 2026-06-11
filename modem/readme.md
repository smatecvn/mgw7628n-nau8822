# Modem Firmware Upgrade Guide

## Prerequisites

- Ensure the device has an active Internet connection.
- Ensure the target firmware version is available on the firmware repository.
- Ensure the correct modem is installed in the device.
- Do not power off the device during the upgrade process.

## Supported Modems

| Modem | USB VID:PID |
|---------|------------|
| A7600 | 1e0e:9011 |
| CLM920 | 1286:4e3c |

The upgrade script automatically verifies the modem type before starting the upgrade to prevent firmware mismatch.

---

## Upgrade Procedure

### Step 1: Download the upgrade script

Copy the script `update_modem.sh` to the following directory:

```bash
/mnt/mmcblk0p1
```

### Step 2: Change to the script directory

```bash
cd /mnt/mmcblk0p1
```

### Step 3: Make the script executable

```bash
chmod +x update_modem.sh
```

### Step 4: Run the firmware upgrade

Syntax:

```bash
./update_modem.sh -m <MODEM> -v <FW_VERSION>
```

Parameters:

| Parameter | Description |
|------------|------------|
| `-m` | Modem type (`A7600` or `CLM920`) |
| `-v` | Firmware version |

Examples:

Upgrade A7600:

```bash
./update_modem.sh -m A7600 -v A81C4B04A7600M7
```

Upgrade CLM920:

```bash
./update_modem.sh -m CLM920 -v CLM920_JC3_V4.7
```

---

## Upgrade Process

The script will automatically:

1. Verify the connected modem using USB Vendor ID and Product ID.
2. Stop related services and processes.
3. Download the firmware downloader utility if not already present.
4. Download the selected firmware package.
5. Upgrade the modem firmware.
6. Verify the upgrade result.
7. Reboot the modem module.
8. Restart system services.

---

## Modem Verification

Before upgrading, the script verifies the modem type:

| Modem | Expected VID:PID |
|---------|------------|
| A7600 | 1e0e:9011 |
| CLM920 | 1286:4e3c |

If the detected modem does not match the selected modem type, the upgrade will be aborted.

Example:

```text
ERROR: Expected modem not found
Expected VID:PID = 1e0e:9011
```

This prevents accidental firmware upgrades to the wrong modem.

---

## Successful Upgrade

If the upgrade is successful, the following message will be displayed:

```text
Firmware upgrade SUCCESS
```

The modem module will then be rebooted automatically.

Example:

```text
=======================================
Firmware upgrade SUCCESS
=======================================

Restarting modem...
Modem rebooted
```

---

## Failed Upgrade

If the upgrade fails, the following message will be displayed:

```text
Firmware upgrade FAILED
```

or

```text
ERROR: Downloader exited with code <code>
```

Check the upgrade log for troubleshooting:

A7600:

```bash
cat /tmp/a7600_upgrade.log
```

CLM920:

```bash
cat /tmp/clm920_upgrade.log
```

---

## Services Affected During Upgrade

The script temporarily stops the following services/processes before upgrading:

- cron
- mgwp_app
- mgwp.pyc

These services are automatically restarted when the script exits, regardless of whether the upgrade succeeds or fails.

---

## Notes

- Do not interrupt the upgrade process.
- Do not power off the device while firmware is being written.
- The upgrade may take several minutes depending on firmware size and module response time.
- Ensure the selected modem type matches the installed hardware.
- Ensure the firmware version corresponds to the selected modem.
- A modem reboot will be performed automatically after a successful upgrade.