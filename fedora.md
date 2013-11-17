Fedora 20 Installation
======================

1. Install ssh server, various tools needed

        sudo yum install openssh-server net-tools wget ntpdate
        sudo systemctl enable ntpdate.service
        sudo systemctl start ntpdate.service

2. Add ssh keys to github

        ssh-keygen
        cat ~/.ssh/id_rsa.pub  #then copy to clipboard
        # add ssh key to github account at https://github.com/settings/ssh

1. Install pulseaudio

        sudo yum install pulseaudio-module-bluetooth alsa-firmware

        # add user to audio group
        vi /etc/group   #find audio group, add user name

1. Install bluez

        sudo yum install gcc glib2-devel dbus-devel systemd-devel libical-devel readline-devel
        mkdir src
        cd src
        git clone git@github.com:terriblelabs/bluez.git
        cd bluez
        ./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var --enable-library
        make
        sudo make install

1. Start bluetoothd

        sudo service bluetooth start
        sudo systemctl daemon-reload


1. Plug in dongle(s); Pair and trust bluetooth device

        $ bluetoothctl
        [NEW] Controller 00:02:72:3F:AC:0C localhost.localdomain [default]
        [bluetooth]# power on
        Changing power on succeeded
        [CHG] Controller 00:02:72:3F:AC:0C Powered: yes
        [bluetooth]# scan on
        Discovery started
        [CHG] Controller 00:02:72:3F:AC:0C Discovering: yes
        [NEW] Device 54:E4:3A:C8:FB:D6 Joe Lind’s iPad
        [bluetooth]# pair 54:E4:3A:C8:FB:D6
        Attempting to pair with 54:E4:3A:C8:FB:D6
        [CHG] Device 54:E4:3A:C8:FB:D6 Connected: yes
        [CHG] Device 54:E4:3A:C8:FB:D6 Modalias: bluetooth:v004Cp6D0Bd0710
        [CHG] Device 54:E4:3A:C8:FB:D6 UUIDs:
          00000000-deca-fade-deca-deafdecacafe
          00001000-0000-1000-8000-00805f9b34fb
          0000110a-0000-1000-8000-00805f9b34fb
          0000110c-0000-1000-8000-00805f9b34fb
          0000110e-0000-1000-8000-00805f9b34fb
          00001116-0000-1000-8000-00805f9b34fb
          0000111f-0000-1000-8000-00805f9b34fb
          00001132-0000-1000-8000-00805f9b34fb
          00001200-0000-1000-8000-00805f9b34fb
        [CHG] Device 54:E4:3A:C8:FB:D6 Paired: yes
        Pairing successful
        [CHG] Device 54:E4:3A:C8:FB:D6 Connected: no
        [bluetooth]# trust 54:E4:3A:C8:FB:D6
        [CHG] Device 54:E4:3A:C8:FB:D6 Trusted: yes
        Changing 54:E4:3A:C8:FB:D6 trust succeeded
        [CHG] Device 54:E4:3A:C8:FB:D6 RSSI: -74
        [CHG] Device 54:E4:3A:C8:FB:D6 Connected: yes

1. Clone/setup project

        git clone git@github.com:terriblelabs/ble-prototype.git
        cd ble-prototype
        sudo yum install npm coffee-script expat-devel
        npm install

1. Run program

        su #run the rest as root
        pulseaudio -D
        ./shell.coffee
        cybex> start

1. On mobile device, connect bluetooth

1. On mobile device, make sure iTunes is running (or some other audio app)

1. In shell prompt, you should be able to use play, metadata, pause, next, previous, etc to manage music

1. Using LightBlue on a Mac or iOS, or nRF control panel on android, you should be able to see the peripheral and read/ subscribe to / write to its characteristics. You can change the values via the set <service> <attribute> command in the console.  You can view the current values with the services command.

1. Start up a Bluetooth HRM (or simulate one with LightBlue on iOS).  You should see heart rate service values propagate up through to the peripheral.
