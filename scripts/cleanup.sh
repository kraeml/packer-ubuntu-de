#!/bin/bash -eux
if [[ -f /etc/apt/apt.conf.d/01proxy ]]; then
  rm /etc/apt/apt.conf.d/01proxy
fi
echo "==> Recording box generation date"
date > /etc/vagrant_box_build_date

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

rm -rf /tmp/*

# Uninstall Ansible and remove PPA.
if [[ ! -f /etc/kraeml_devops ]]; then
  apt -y remove --purge ansible
  apt-add-repository --remove ppa:ansible/ansible
fi

# Apt cleanup.
apt --yes autoremove
apt-get --yes clean
apt-get --yes autoclean

# Clean up log files
find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;

echo "==> Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# Zero out the rest of the free space using dd, then delete the written file.
echo "==> Whiteout root"
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count
dd if=/dev/zero of=/EMPTY bs=1M count=$count
rm -f /EMPTY

echo '==> Clear out swap and disable until reboot'
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    echo "swapuuid: $swapuuid"
    echo "swappart: $swappart"
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

echo "==> Delete unneeded files"
rm -f /home/vagrant/*.sh

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

echo "==> Disk usage before cleanup"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "==> Disk usage after cleanup"
df -h
