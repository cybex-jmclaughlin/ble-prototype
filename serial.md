1. Update hostname

        root@beaglebone:~# echo venus > /etc/hostname

1. Update packages

        root@venus:~# opkg update

1. Set timezone / clock

        root@venus:~# rm /etc/localtime
        root@venus:~# ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
        root@venus:~# ntpdate 0.pool.ntp.org

1. Add ssh-keygen (needed to upload key to github)

        opkg install openssh-keygen

1. Create ssh key and upload to github

        ssh-keygen
        cat ~/.ssh/id_rsa.pub
        https://github.com/settings/ssh
        "add new ssh key"

1. Set git configuration

        root@venus:~# git config --global user.name "USERNAME"
        root@venus:~# git config --global user.email "EMAIL"

1. Install dependencies

        opkg install gnome-bluetooth-dev
        opkg install python-compiler python-misc python-multiprocessing

        # Must link libstdbuf.so into /user/libexec/cureutils, else stdbuf fails!
        ln -s /usr/lib/coreutils/libstdbuf.so /usr/libexec/coreutils/

1. Enable bluetooth in connman

        root@venus:~# cat /var/lib/connman/settings
        [global]
        OfflineMode=false

        [Wired]
        Enable=true

        [WiFi]
        Enable=true

        [Bluetooth]
        Enable=false   # <<< SET TO TRUE

1. Clone project

        venus:~/projects$ git clone git@github.com:terriblelabs/ble-prototype.git


1. Install node dependencies

        venus:~/projects/ble-prototype$ npm update -g npm
        venus:~/projects/ble-prototype$ npm install -g 'https://github.com/TooTallNate/node-gyp/tarball/master'
        venus:~/projects/ble-prototype$ npm install -g coffee-script

1. Install node project dependencies

        venus:~/projects/ble-prototype$ npm install

1. Restart connman

        systemctl restart connman.service

1. Bring up bluetooth device

        root@venus:~/ble-prototype# hciconfig
        hci0:	Type: BR/EDR  Bus: USB
          BD Address: 00:02:72:C6:E4:6B  ACL MTU: 1021:8  SCO MTU: 64:1
          DOWN
          RX bytes:495 acl:0 sco:0 events:22 errors:0
          TX bytes:369 acl:0 sco:0 commands:22 errors:0

        root@venus:~/ble-prototype# hciconfig hci0 up
        root@venus:~/ble-prototype# hciconfig
        hci0:	Type: BR/EDR  Bus: USB
          BD Address: 00:02:72:C6:E4:6B  ACL MTU: 1021:8  SCO MTU: 64:1
          UP RUNNING
          RX bytes:990 acl:0 sco:0 events:44 errors:0
          TX bytes:738 acl:0 sco:0 commands:44 errors:0

1. Start shell program

        root@venus:~/ble-prototype# ./shell.coffee
        Type "help" or press enter for a list of commands
        cybex> start
        Starting peripheral...started

1. Inspect GATT services that are available

        cybex> services
        Peripheral CybexBlePeripheral
          Service workout
            UUID: 1ca931a86a774e4daad85ca168163ba6
            Characteristics:
              elapsed_seconds:              1799649b7c9948b198cf0b7dcda597a7                 null
              meters_travelled:             45186dd606e744a2a5eabc9c45b7e2b5                 null
              meters_per_hour:              b7cf5c639c0740c7a6ad6aa6d8ed031d                 null
              calories_burned:              3d00bef9375d40de88dbf220631bd8a4                 null
              calories_per_hour:            ac869a9f975444aba280c61b7a6d15be                 null
              current_power:                6e1ea3e8cf5e45c5a61c2f338220a77f                 null
              current_heart_rate:           c9f0dcbfdd994282b74bac44bb5c013e                 null
              strides_per_minute:           065806b97ac64dccb42c96bb712e0ceb                 null
              current_mets:                 e4a234eadc684b07b435485b9b3406fd                 null
          Service equipment
            UUID: 5748216d3c4a491e9138467824e8f270
            Characteristics:
              serial:                       6e12ade711b044f7921a0c11fb9b2bd1                 null
              model:                        74371ef24c104494be1a0503fc844cc9                 null

1. Set elapsed_seconds

        cybex> set workout elapsed_seconds 99
        cybex> services
        Peripheral CybexBlePeripheral
          Service workout
            UUID: 1ca931a86a774e4daad85ca168163ba6
            Characteristics:
              elapsed_seconds:              1799649b7c9948b198cf0b7dcda597a7                   99
              meters_travelled:             45186dd606e744a2a5eabc9c45b7e2b5                 null
              meters_per_hour:              b7cf5c639c0740c7a6ad6aa6d8ed031d                 null
              calories_burned:              3d00bef9375d40de88dbf220631bd8a4                 null
              calories_per_hour:            ac869a9f975444aba280c61b7a6d15be                 null
              current_power:                6e1ea3e8cf5e45c5a61c2f338220a77f                 null
              current_heart_rate:           c9f0dcbfdd994282b74bac44bb5c013e                 null
              strides_per_minute:           065806b97ac64dccb42c96bb712e0ceb                 null
              current_mets:                 e4a234eadc684b07b435485b9b3406fd                 null
          Service equipment
            UUID: 5748216d3c4a491e9138467824e8f270
            Characteristics:
              serial:                       6e12ade711b044f7921a0c11fb9b2bd1                 null
              model:                        74371ef24c104494be1a0503fc844cc9                 null

1. Using LightBlue app on mac, verify that new values are set (use read/subscribe/write)

1. Quit shell

        cybex> quit
        Stopping peripheral

        root@venus:~/ble-prototype#

1. Connect serial port to equipment

1. Start serial port MCC program

        root@venus:~/ble-prototype# ./serial

1. Using LightBlue (or iPad app), connect to peripheral and verify that values update over BLE connection
