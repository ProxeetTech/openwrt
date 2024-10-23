#!/bin/bash

# Get the directory where the script is located
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR=$1
ROOTFS_IMG=$SCRIPT_DIR/$2

# Paths to your build artifacts      
KERNEL_IMAGE="$SCRIPT_DIR/Image.gz"
DEVICE_TREE="$SCRIPT_DIR/lan969x_ev23x71a.dtb"
UNCOMPRESSED_ROOTFS="$SCRIPT_DIR/rootfs.cpio"
URAMDISK_IMAGE="$SCRIPT_DIR/uRamdisk"

# Name of the output FIT image
FIT_IMAGE="$SCRIPT_DIR/fit.itb"

# Create FIT image description (its file)
FIT_SOURCE="$SCRIPT_DIR/fit.its"

# Check if the kernel image exists
if [[ ! -f "$KERNEL_IMAGE" ]]; then
  echo "Error: Kernel file ($KERNEL_IMAGE) not found!"
  exit 1
fi

# Check if the Device Tree Blob exists
if [[ ! -f "$DEVICE_TREE" ]]; then
  echo "Error: Device Tree ($DEVICE_TREE) not found!"
  exit 1
fi

# Check if the rootfs cpio.gz file exists
if [[ ! -f "$ROOTFS_IMG" ]]; then
  echo "Error: Rootfs file ($ROOTFS_IMG) not found!"
  exit 1
fi

# Uncompress the rootfs cpio.gz
echo "Uncompressing $ROOTFS_IMG..."
gzip -d -c "$ROOTFS_IMG" > "$UNCOMPRESSED_ROOTFS"
if [[ $? -ne 0 ]]; then
  echo "Error uncompressing rootfs!"
  exit 1
fi

# Create uRamdisk from the uncompressed rootfs
echo "Creating uRamdisk from $UNCOMPRESSED_ROOTFS..."
mkimage -A arm64 -O linux -T ramdisk -d "$UNCOMPRESSED_ROOTFS" "$URAMDISK_IMAGE"
if [[ $? -ne 0 ]]; then
  echo "Error creating uRamdisk!"
  exit 1
fi

cat << EOF > $FIT_SOURCE
/dts-v1/;
/ {
    description = "Image Tree Source file for sparx5";
    #address-cells = <1>;

    images {
        kernel {
            description = "Kernel";
            data = /incbin/("$KERNEL_IMAGE");
            type = "kernel";
            arch = "arm64";
            os = "linux";
            compression = "gzip";
            load = /bits/ 64 <0x60000000>;
            entry = /bits/ 64 <0x60000000>;
        };

        fdt_lan9698_ev23x71a_0_at_lan969x {
            description = "Flattened Device Tree";
            data = /incbin/("$DEVICE_TREE");
            type = "flat_dt";
            arch = "arm64";
            compression = "none";
        };

        ramdisk {
            description = "Ramdisk";
            data = /incbin/("$UNCOMPRESSED_ROOTFS");
            type = "ramdisk";
            arch = "arm64";
            os = "linux";
            compression = "none";
            load = /bits/ 64 <0x64000000>;
        };

    };

    configurations {
        default = "lan9698_ev23x71a_0_at_lan969x";
        
        lan9698_ev23x71a_0_at_lan969x {
            description = "Kernel with DT fdt_lan9698_ev23x71a_0_at_lan969x";
            kernel = "kernel";
            fdt = "fdt_lan9698_ev23x71a_0_at_lan969x";
            ramdisk = "ramdisk";
        };
    };
};
EOF

# Create FIT image using mkimage
echo "Creating FIT image..."
mkimage -f $FIT_SOURCE $FIT_IMAGE

# Check if FIT image was successfully created
if [[ $? -eq 0 ]]; then
  echo "FIT image successfully created: $FIT_IMAGE"
else
  echo "Error creating FIT image"
  exit 1
fi

# Copy itb to /srv/tftp
echo "Copying FIT image..."
cp $FIT_SOURCE $FIT_IMAGE /srv/tftp/

# Check if FIT image was successfully copied
if [[ $? -eq 0 ]]; then
  echo "FIT image successfully copied to /srv/tftp/"
else
  echo "Error while copying FIT image"
  # exit 1
fi

