# Embed common.ign in the ISO

    coreos-installer download -f iso
    coreos-installer iso ignition embed -i ./ignition/common/common.ign -o coreos.iso fedora-coreos-*-live.aarch64.iso

# Installing on nodes

    sudo coreos-installer install /dev/sda -n -I http://10.211.55.2:8000/bootstrap.ign --insecure-ignition
