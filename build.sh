#!/bin/bash
# based on the instructions from edk2-platform

#########################################################
# Set up

set -e
. build_common.sh

board="FxtecPro"
boardPkg="${board}Pkg"
fdLocation="workspace/Build/${boardPkg}/DEBUG_GCC5/FV/MSM8998PKG_UEFI.fd"
dtbLocation="${boardPkg}/Dtb/${board}.dtb"
ramdiskLocation="Utilities/initrd.gz"
xbl_path="xbl.elf"

#########################################################
# Cleanup
if [ -f k ] ; then rm k; fi
if [ -f boot.img ] ; then rm boot.img; fi
if [ -d workspace/proprietary ] ; then rm -r workspace/proprietary; fi

#########################################################
# Extract xbl
mkdir -p workspace/proprietary/xbl
mkdir -p workspace/proprietary/section0_extracted
uefi-firmware-parser -b -o workspace/proprietary/xbl/ -e "$xbl_path"
7z e workspace/proprietary/xbl/volume-498048/file-9e21fd93-9c72-4c15-8c4b-e77f1db2d792/section0.guid -oworkspace/proprietary
uefi-firmware-parser -b -o workspace/proprietary/section0_extracted/  -e workspace/proprietary/section0

#########################################################
# build
# not actually GCC5; it's GCC7 on Ubuntu 18.04.
GCC5_AARCH64_PREFIX=aarch64-linux-gnu- build -s -n 0 -a AARCH64 -t GCC5 -p ${boardPkg}/${boardPkg}.dsc


#########################################################
# Pack-up
# GZip result fd and append dtb to it to make a faux-zImage
(gzip -9 -c < $fdLocation ;cat $dtbLocation ) > k; 

# Make aboot-compatible bootimg, we also need a dummy rootfs
python Utilities/$HOSTTYPE/mkbootimg \
   --header_version 1 --pagesize 4096 --id --os_version 10.0 --os_patch_level 2020-01-01 \
   --kernel k --ramdisk $ramdiskLocation --cmdline 'androidboot.hardware=qcom earlycon' -o boot.img ;

# Run AVBTool to pass Android Verified Boot bs
./Utilities/$HOSTTYPE/avbtool \
   add_hash_footer --image boot.img \
   --partition_size 0x04000000 --partition_name boot; \
