install:
	cp ./main.nu /etc/libvirt/hooks/qemu
	cp ./main.nu /etc/libvirt/hooks/lxc
	cp ./main.nu /etc/libvirt/hooks/libxl
	cp ./main.nu /etc/libvirt/hooks/bhyve
	cp ./main.nu /etc/libvirt/hooks/network
	chmod +x /etc/libvirt/hooks/{qemu,l{xc,ibxl},bhyve,network}

install_example_gaming_vfio_as_default:
	mkdir -p /etc/libvirt/hooks/qemu.d/
	cp -r ./examples/asus-gaming-vfio/ /etc/libvirt/hooks/qemu.d/
	mv /etc/libvirt/hooks/qemu.d/asus-gaming-vfio /etc/libvirt/hooks/qemu.d/default
	fd *.nu /etc/libvirt/hooks/qemu.d/default/ -X chmod +x {}
