# libvirt hooks nushell

A conventional and user-friendly Libvirt hook script written in Nushell, offering enhanced flexibility for those who prefer simplicity, laziness and convenience, like myself.

## Distinguishable Features

- Disable Hooking for Specific VMs: You can easily disable the entire hook system for any VM by simply appending specific suffixes to the VM name. If a VM name ends with:
  - "-woh", "-without-hooks", "-nh", or "-no-hooks", hooks will be disabled for that VM.
- Default Hooks for Simplicity: For users who manage multiple VMs with identical configurations, the default hooks can be enabled automatically. No need to write redundant code!
- Disable Default Hooks: Disable the default hook system for any VM by appending:
  - "-nd", "-no-default", "-wod", or "-without-default" to the VM name.

## Generic Folder Structure

```
/etc/libvirt/hooks/
  - qemu # (main.nu file in this case)
  - qemu.d # (where your custom hooks go)
```

Below is an example folder structure, if you want, you can make them one single script in `/etc/libvirt/hooks/qemu.d/win11vm`, but consider managing command line arguments, you can
read more about [libvirt hooks here](https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/).

```
/etc/libvirt/hooks/qemu.d/
  - win11vm
    - prepare
      - begin
        - 00-reserve-hugepages
        - 01-isolate-cpus
        - 02-etc.
    - stopped
      - end
        - 99-release-hugepages
        - 98-revert-cpus
        - 97-etc.
```

## Installation

```
git clone https://github.com/atahabaki/libvirt-hooks-nushell/
cd libvirt-hooks-nushell
source toolkit.nu
install
```

That's it. The only thing left is configuration, writing the hooks or default-hooks for your own VMs, take care.

After install make sure to restart `libvirtd` sytemd service, as below:

```
systemctl restart libvirtd
```
