Fedora Command Line Install
use network adapter in bridged mode

login as root

    yum install net-tools

    /sbin/service sshd start
    #(to get ip address)
    ifconfig

ssh in from host (to copy/paste install script)

    sudo yum install wget gcc glib2-devel dbus-devel systemd-devel libical-devel readline-devel
    mkdir src
    cd src
    wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.20.tar.xz
    tar -xvJf bluez-5.20.tar.xz

    cd bluez-5.20
    ./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var

    # comment out the following in adapter.c
    #btd_adapter_gatt_server_start(adapter);
    #btd_adapter_gatt_server_stop(adapter);

    sed -i '4200 s/^/\/\//' src/adapter.c
    sed -i '6104 s/^/\/\//' src/adapter.c

    make
    sudo make install

Set up ssh keys, etc

    ssk-keygen
    cat ~/.ssh/id_rsa.pub   # copy to github

clone ble prototype

    sudo service bluetooth start
    sudo yum install npm coffee-script bluez-libs-devel
    cd ~/src
    git clone git@github.com:terriblelabs/ble-prototype.git
    cd ble-prototype
    git checkout heart-rate
    npm install
    sudo ./shell.coffee


bluetoothctl [NEW] Controller 00:02:72:C6:E4:6B localhost.localdomain [default] [NEW] Device F0:D1:A9:67:6B:9C Joe's iPhone [NEW] Device 2C:B4:3A:2A:C2:5F 2C-B4-3A-2A-C2-5F [NEW] Device F4:F9:51:DF:67:71 F4-F9-51-DF-67-71 [bluetooth]# scan on Discovery started [CHG] Controller 00:02:72:C6:E4:6B Discovering: yes [CHG] Device 2C:B4:3A:2A:C2:5F RSSI: -99 [bluetooth]# agent on Agent registered [bluetooth]# pair F0:D1:A9:67:6B:9C [bluetooth]# connect F0:D1:A9:67:6B:9C Attempting to connect to F0:D1:A9:67:6B:9C [CHG] Device F0:D1:A9:67:6B:9C Connected: yes Connection successful
