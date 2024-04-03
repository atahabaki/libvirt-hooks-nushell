#!/bin/nu
use std log
source ../../vm_vars.nu

def main [...args] {
	log info "Isolation started for VM_OFF."
	let parameter = $"AllowedCPUs=($env.SYS_TOTAL_CPUS)"
	systemctl set-property --runtime -- user.slice $parameter
	systemctl set-property --runtime -- system.slice $parameter
	systemctl set-property --runtime -- init.slice $parameter
	log info "Isolation finished."
}
