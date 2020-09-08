#!/bin/sh
#points to a separate tmp dir as dpkg have some packages require exec on the said directory
echo "pre-run Set dpkg tmp to dir with allowed exec"
if [ -f "/etc/apt/apt.conf.d/50extracttemplates" ]
then
        echo "config for moving the dpkg temp dir created. skipping..."
else
        mkdir -p /var/local/tmp
        touch /etc/apt/apt.conf.d/51extracttemplates
        echo 'APT
{
  ExtractTemplates
  {
        TempDir "/var/local/tmp";
  };
};' >> /etc/apt/apt.conf.d/50extracttemplates
        echo "Successfully created custom apt tmp dir."
fi

echo "1.1.2 Ensure separate partition exists for /tmp"
# ensure not to rerun the script if it has already been performed before
if ! df -T /tmp | awk '/^\/dev/ {print $1}' | grep -Eq '^/dev/loop[0-9]$'; then
        # create necessary directories
        mkdir -p /root/tmp
        # create filesystem with ext4 type, 1gb in size
        dd if=/dev/zero of=/dev/tmp.bin bs=1 count=0 seek=1G
        mkfs.ext4 /dev/tmp.bin
        # temporarily mount to a separate dir as we will be synching the contents from the original tmp dir
        # allow read-write, no device access, disable switching user id, disable executables for this partition
        mount -o loop,rw,nodev,nosuid,noexec /dev/tmp.bin /root/tmp
        # stop services
        service supervisor stop
        service redis-server stop
        # perform copy, trailing slash on source so it won't be contained on the /tmp directory
        rsync -av /tmp/ /root/tmp
        # remount/bind it to /tmp
        umount -l /root/tmp
        mount -o loop,rw,nodev,nosuid,noexec /dev/tmp.bin /tmp
        # make it world writable
        chmod 1777 /tmp
        # update fstab, so it would persist on reboot
        echo "/dev/tmp.bin /tmp ext4 loop,rw,noexec,nosuid,nodev 0 0" >> /etc/fstab
        # restart services
        service supervisor start
        service redis-server start
        # cleanup
        rmdir /root/tmp
        echo "done."
else
        echo "partition for /tmp already exists"
fi
