# qbastrial_ebvdemo
A self-installing, self-config script to install ebv demos on qb-astrial "vanilla" image.

The following instructions allow you to flash the camera with a prebuilt image (.wic), connect the camera to the network and then install the ebv simple demo (obj detection, pose detection, face landmarks, segmentation). The current demo requires to have the latest HailoRT > v.4.23 on the board to properly run the demos.

The final setup is composed by one or more qb-astrial, one PoE ethernet switch and a laptop to decode the video streams. The final setup is isolated from the internet and will run with fixed ip address for both qbastrial and laptop.


# flash qb-astrial 
To flash the camera you do NOT need the PoE switch, you need the USB cable from the camera to the pc (ubuntu linux)

You have downloaded your astrial image, make sure it is the correct one based on memory size (4gb or 8gb) of the module.
If the image is compressed (.wic.zst) the uncompress the image using the "unzst" command from commandline on your ubuntu pc.

Once ready follow these steps in this EXACT order:
## programming dongle insertion
Insert the dongle first, without attaching the usb cable to the pc

## pc connection
Insert the usb-c cable into the dongle and then into the pc.
IMPORTANT you must follow this exact order to avoid ESD damage while programming via usb.

## flashing
Once the camera is connected to the pc use the UUU command to flash the camera:

```
sudo uuu -b emmc_all ./imx-boot-astrial-8gb-imx8mp-sd.bin-flash_evk ./system-astrial-image-astrial-8gb-imx8mp.wic
```
If you do not have UUU installed you can get the command by typing:

```
wget https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.125/uuu
chmod +x ./uuu
```
## disconnect and reboot
To disconnect the camera please follow the reverse order of operations: first remove the cable from your pc, then remove the cable from the camera dongle (but leave the dongle inserted).
Last remove the dongle from the camera.


curl -O -s https://raw.githubusercontent.com/gfilippi/qbastrial_ebvdemo/refs/heads/main/fetch.py && chmod 754 ./fetch.py && ./fetch.py
