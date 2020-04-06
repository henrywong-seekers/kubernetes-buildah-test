#!/bin/sh

mkdir -p /var/lib/shared/vfs-images
mkdir -p /var/lib/shared/vfs-layers

touch /var/lib/shared/vfs-images/images.lock
touch /var/lib/shared/vfs-layers/layers.lock
sed -i -e 's|^mount_program|#mount_program|g' -e 's|^mountopt|#mountopt|g' /etc/containers/storage.conf
