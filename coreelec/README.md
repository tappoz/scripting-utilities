# CoreELEC

https://coreelec.org

# MXQ Pro 4K (Amlogic)

- DTB: gxl_p212_1g (`Copy this DTB from the 'device_trees' subfolder to the root of your SD card and rename it to 'dtb.img'`)
- SOC: S905X
- https://github.com/CoreELEC/CoreELEC/releases/download/9.2.0/CoreELEC-Amlogic.arm-9.2.0-Generic.img.gz

```
cp device_trees/gxl_p212_1g.dtb .
mv gxl_p212_1g.dtb dtb.img
```

# Setup (Amlogic)

MXQ-PRO 4K AMLOGIC S905 SOC - LibreELEC Install Dual Boot SD Card Tutorial
https://www.youtube.com/watch?v=3LZwX1dwQB8

https://mxqproject.com/coreelec-9-kodi-18-dedicated-amlogic-libreelec-for-s905-and-s912-tv-boxes/

CORE ELEC DUAL BOOT TUTORIAL: AMLOGIC S905, S912 TV BOXES - LIBREELEC MINOR UPDATE FORK
https://mxqproject.com/coreelec-takes-over-minor-libreelec-fork-for-amlogic-android-tv-boxes/

https://mxqproject.com/coreelec-a-minor-libreelec-fork/

# MXQ Pro 4K (Allwinner H3 Quad-Core)

## Linux Sunxi

- http://linux-sunxi.org/MXQ-4K
- http://linux-sunxi.org/Manual_build_howto
- https://wikidevi.com/wiki/GUANZHI_Android_TV_BOX_H3
- http://linux-sunxi.org/H3_Manual_build_howto

```
apt-get install gcc-arm-linux-gnueabihf
```

# Mecool M8S Pro L (Amlogic)

To find the IP address of the TV box given the MAC address, we know it ends with
`XX:YY`, so we can do:

```sh
sudo arp-scan 192.168.0.1/24 2>&1 | grep XX:YY
```

## Reboot the TV box

- Boot Into ANDROID TV Box Recovery Without The RESET Button - Easy Peasy With Terminal App
  https://www.youtube.com/watch?v=qBH-bjWgVjE
- Reboot to LibreELEC 1.1 APK (Thomas van Tilburg)
    - https://apkplz.net/app/me.thomastv.rebootupdate
    - https://play.google.com/store/apps/details?id=me.thomastv.rebootupdate&hl=en
- Install a Terminal APK for Android, then run `reboot update`

## UART logging (Universal Asynchronous Receiver/Transmitter)

- http://mxqproject.com/uart-for-amlogic-allwinner-and-rockchip-devices-setting-up-guide/
    - UART for Amlogic Allwinner and Rockchip Android TV Boxes: How To Connect Guide Tutorial
      https://www.youtube.com/watch?v=uSuFVntxRg0
- Serial console program
    - HyperTerm
    - minicom
- Use `screen`:
    - check the USB ports that are plugged with `lsusb | grep USB` and `ls -l /dev/ttyUS*`
      (e.g. `/dev/ttyUSB1`)
    - then check what is being written on the serial port with `screen /dev/ttyUSB1 115200`
      where `115200` is the baud rate for Amlogic chips (for Rockchip devices that's `15000`)
- FTDI connector:
    - CH340G
    - https://learn.sparkfun.com/tutorials/how-to-install-ch340-drivers/all

The UART pins are not marked so using a multimeter:

- To find `GND` and `3.3V`: use the "continuity test" and check it agains
  another ground e.g. on a capacitor.
- To find `TX` and `RX`:

## Default android

```
# check open ports...
$ nc -vz 192.168.0.XXX 1-10000 2>&1 | grep -v refused
Connection to 192.168.0.XXX 5555 port [tcp/*] succeeded!
Connection to 192.168.0.XXX 6466 port [tcp/*] succeeded!
Connection to 192.168.0.XXX 6467 port [tcp/*] succeeded!
```


Download the APK to reboot (Reboot to LibreELEC 1.1 APK (Thomas van Tilburg))

```
wget --content-disposition https://d-02.apkplz.org/dl.php?s=bkxnUnJvK1U4QmZaZFIwRnU3NHlkQWdLNXNyY2t5c3FXQTducFluaHRqQVVGSzhZSmxLdnhVZkhiYTF3ZUlxQ3kwenVhTFVJQnNJTEpLMkhsQ2V2cUU4RUxtYXdrRTZ3aDhySkJJRm9Cd1JGWldOdEpEeU4vcmhaeU5PZEpSRWo3K3RyRm0yWkk2Q2QvV2lHTXZ4RjN3PT0=
``

Install and execute the App to reboot the TV box

```sh
# Connect to the Android TV (default on port 5555)
adb connect 192.168.0.XXX
# Check the list of devices (it should say something about being "unauthorized")
adb devices -l
# You should now see on the TV screen a popup window asking if you want to
# enable the debug mode, hit "YES" with your remote controller
# Check again the list of devices (now saying something like "device product:q20x model:M8S_PRO_L device:M8S_PRO_L_4335 transport_id:2")
adb devices -l
# Install the APK (that below is the filename in the current directory)
adb install me.thomastv.rebootupdate_11_apkplz.net.apk
# Check the Java package name of the App (pkg, or pkn) from the logs
adb logcat | grep thomastv
# Run the App
adb shell monkey -p me.thomastv.rebootupdate  -c android.intent.category.LAUNCHER 1
# Hit the "OK" button of the remote controller when asked from the screen to reboot
```

### Uninstall the Reoot app

```
# find the app
$ adb shell pm list packages -f | grep thomastv
package:/data/app/me.thomastv.rebootupdate-1/base.apk=me.thomastv.rebootupdate
# uninstall the app/apk using the package name
$ adb uninstall me.thomastv.rebootupdate
Success
```

### Alternative method to reboot the TV Box

```
adb reboot update
adb shell reboot update
```

# CoreELEC

- Use a USB mouse to go through the setup wizard (**enable SSH**).
- `ssh root@192.168.0.XXX` then use `coreelec` as password.
