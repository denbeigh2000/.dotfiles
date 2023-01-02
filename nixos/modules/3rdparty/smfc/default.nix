{ ... }:

let
  conf = args: ''
    [Ipmi]

    # Path for ipmitool (str, default=/usr/bin/ipmitool)
    command=${pkgs.ipmitool}/bin/ipmitool
    # Delay time after changing IPMI fan mode (int, seconds, default=10)
    fan_mode_delay=10
    # Delay time after changing IPMI fan level (int, seconds, default=2)
    fan_level_delay=2

    [CPU zone]
    # Fan controller enabled (bool, default=0)
    enabled=1
    # Number of CPUs (int, default=1)
    count=1
    # Calculation method for CPU temperatures (int, [0-minimum, 1-average, 2-maximum], default=1)
    temp_calc=1
    # Discrete steps in mapping of temperatures to fan level (int, default=6)
    steps=6
    # Threshold in temperature change before the fan controller reacts (float, C, default=3.0)
    sensitivity=3.0
    # Polling time interval for reading temperature (int, sec, default=2)
    polling=2
    # Minimum CPU temperature (float, C, default=30.0)
    min_temp=30.0
    # Maximum CPU temperature (float, C, default=60.0)
    max_temp=60.0
    # Minimum CPU fan level (int, %, default=35)
    min_level=35
    # Maximum CPU fan level (int, %, default=100)
    max_level=100
    # Optional parameter, it will be generated automatically (can be used for testing and in special cases).
    # Path for CPU sys/hwmon/coretemp file(s) (str multi-line list, default=/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input)
    # hwmon_path=/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input
    #            /sys/devices/platform/coretemp.1/hwmon/hwmon*/temp1_input

    [HD zone]
    # Fan controller enabled (bool, default=0)
    enabled=1
    # Number of HDs (int, default=1)
    count=1
    # Calculation of HD temperatures (int, [0-minimum, 1-average, 2-maximum], default=1)
    temp_calc=1
    # Discrete steps in mapping of temperatures to fan level (int, default=4)
    steps=4
    # Threshold in temperature change before the fan controller reacts (float, C, default=2.0)
    sensitivity=2.0
    # Polling interval for reading temperature (int, sec, default=10)
    polling=10
    # Minimum HD temperature (float, C, default=32.0)
    min_temp=32.0
    # Maximum HD temperature (float, C, default=46.0)
    max_temp=46.0
    # Minimum HD fan level (int, %, default=35)
    min_level=35
    # Maximum HD fan level (int, %, default=100)
    max_level=100
    # Names of the HDs (str multi-line list, default=)
    # These names MUST BE specified in '/dev/disk/by-id/...' form!
    hd_names=
    # Optional parameter, it will be generated automatically (can be used for testing and in special cases).
    # Path for HD sys/hwmon/drivetemp file(s) (str multi-line list, default=/sys/class/scsi_disk/0:0:0:0/device/hwmon/hwmon*/temp1_input)
    # hwmon_path=/sys/class/scsi_disk/0:0:0:0/device/hwmon/hwmon*/temp1_input
    #            /sys/class/scsi_disk/1:0:0:0/device/hwmon/hwmon*/temp1_input
    # Standby guard feature for RAID arrays (bool, default=0)
    standby_guard_enabled=0
    # Number of HDs already in STANDBY state before the full RAID array will be forced to it (int, default=1)
    standby_hd_limit=1
    # Path for 'smartctl' command (str, default=/usr/sbin/smartctl)
    smartctl_path=/usr/sbin/smartctl
    '';

in
  {}
