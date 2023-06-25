## Recovery Device Tree for the Samsung Galaxy A01 Core (MTK)

## How-to compile it:

```sh
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
lunch twrp_a01core-eng
make recoveryimage
```
> Work:
- Boot
- ADB
- Install stuff

> Bugs:
- MTP
- Finding more...

Supported Models: SM-A013F, SM-A013G, SM-A013M, SM-M013F.

Blobs version:
> Kernel base: A013FPUU1ATJ4

> Ramdisk, DTB, DTBO base: A013GXXU4AVC6

Kernel source: https://github.com/almondnguyen/android_kernel_samsung_a01core

