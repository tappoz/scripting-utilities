#!/usr/bin/env bash

VERSION=9.2.0
IMG_FILENAME=CoreELEC-Amlogic.arm-${VERSION}-Generic.img
ZIP_FILENAME=${IMG_FILENAME}.gz

IMG_1=img1
IMG_2=img2

if [ ! -f ${ZIP_FILENAME} ]; then
  echo -e "\n\nDownloading ${ZIP_FILENAME}\n\n"
  wget https://github.com/CoreELEC/CoreELEC/releases/download/${VERSION}/${ZIP_FILENAME}
else
  echo -e "\n\nNo need to download ${ZIP_FILENAME}\n\n"
fi

echo -e "\n\nUnzipping ${ZIP_FILENAME}\n\n"
# `yes n` means answering "no" (overwrite) to the interactive prompt
yes n | gunzip -k ${ZIP_FILENAME}

echo -e "\n\nThese are the info about the partitions on: ${IMG_FILENAME}\n\n"
fdisk -l ${IMG_FILENAME}

echo -e "\n\nSector size:"
fdisk -l ${IMG_FILENAME} | grep "Units: sectors of" | awk '{print $8}'

echo -e "\n\n${IMG_1} start block:"
IMG_1_START_BLOCK=$(fdisk -l ${IMG_FILENAME} | grep "${IMG_1}" | awk '{print $3}')
echo "${IMG_1_START_BLOCK}"

echo -e "\n\n${IMG_2} start block:"
IMG_2_START_BLOCK=$(fdisk -l ${IMG_FILENAME} | grep "${IMG_2}" | awk '{print $2}')
echo "${IMG_2_START_BLOCK}"

# TODO mount (check https://linuxconfig.org/how-to-mount-rasberry-pi-filesystem-image)
