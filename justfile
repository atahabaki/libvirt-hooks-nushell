install:
	cp ./main.nu /etc/libvirt/hooks/qemu
	cp ./main.nu /etc/libvirt/hooks/lxc
	cp ./main.nu /etc/libvirt/hooks/libxl
	cp ./main.nu /etc/libvirt/hooks/bhyve
	cp ./main.nu /etc/libvirt/hooks/network
