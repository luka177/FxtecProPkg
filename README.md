# FxtecProPkg
EDK2 for F(x)tec Pro 1 and similar MSM8998-based devices 

Based on zhuowei's port for Pixel3XL (https://github.com/Pixel3Dev/edk2-pixel3/) with further work from fxsheep (https://github.com/fxsheep/edk2-sagit).

## Status 

Can load GRUB2 from a fat partition on the UFS.(any fat partition will work)

## Building
Tested on Ubuntu 18.04.

First, clone EDK2.

```
cd ..
git clone https://github.com/tianocore/edk2.git --recursive
git clone https://github.com/tianocore/edk2-platforms.git
```

You should have all three directories side by side.

Next, install dependencies:

18.04:

```
sudo apt install build-essential uuid-dev iasl git nasm python3-distutils gcc-aarch64-linux-gnu p7zip
sudo pip install uefi-firmware-parser
```

Also see [EDK2 website](https://github.com/tianocore/tianocore.github.io/wiki/Using-EDK-II-with-Native-GCC#Install_required_software_from_apt)

Now you will need xbl.elf (it contains proprietary drivers). You can extract it from device. Place it in same folder as build.sh and name it xbl.elf. 

Finally, ./build.sh.

Then flash boot.img to boot partition with fastboot or dd.

# Credits

SimpleFbDxe screen driver is from imbushuo's [Lumia950XLPkg](https://github.com/WOA-Project/Lumia950XLPkg).
