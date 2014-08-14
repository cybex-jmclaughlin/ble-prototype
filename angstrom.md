
1. Set date

        ntpdate -b -s -u pool.ntp.org

1. Start ssh server (if accessing over network)

        /etc/init.d/dropbear start

1. Add key to github

        opkg install openssh-keygen
        ssh-keygen
        cat ~/.ssh/id_rsa.pub
        https://github.com/settings/ssh
        "add new ssh key"

1. Configure git (optional)

        git config --global user.name "USERNAME"
        git config --global user.email "EMAIL"

1. Enable bluetooth in connman

        vi /var/lib/connman/settings
        Enable=false   # <<< SET TO TRUE

        systemctl restart connman.service

1. Install Dependencies

        opkg install dbus-dev systemd-dev libical-dev

1. Download and build bluez

        mkdir src
        cd src

        curl -k -o bluez-5.22.tar.xz https://www.kernel.org/pub/linux/bluetooth/bluez-5.22.tar.xz

        tar -xvJf bluez-5.22.tar.xz
        cd bluez-5.22
        ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-library

        make
        make install

1. Clone BLE project

        git clone git@github.com:terriblelabs/ble-prototype.git

1. Install Node dependencies

        opkg install python-compiler python-misc python-multiprocessing
        npm update -g npm
        npm install -g 'https://github.com/TooTallNate/node-gyp/tarball/master'
        npm install -g coffee-script

1. Install node project dependencies

        cd ~/src/ble-prototype
        npm install

1. Start bluetoothd

        systemctl start bluetooth


1. Install pulseaudio (WIP)

        opkg install intltool libjson-dev libsndfile-dev libatomics-ops-dev alsa-lib-dev speex-dev
        cd ~/src
        wget http://freedesktop.org/software/pulseaudio/releases/pulseaudio-5.0.tar.xz
        tar -xvJf pulseaudio-5.0.tar.xz
        ./configure
