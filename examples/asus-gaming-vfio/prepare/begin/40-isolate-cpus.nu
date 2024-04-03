#!/bin/nu
use std log
source ../../vm_vars.nu

def main [...args] {
	log info "Isolation started for VM_ON."
	let parameter = $"AllowedCPUs=($env.VM_ISOLATED_CPUS)"
	systemctl set-property --runtime -- user.slice $parameter
	systemctl set-property --runtime -- system.slice $parameter
	systemctl set-property --runtime -- init.slice $parameter
	log info "Isolation finished."
}
