#!/bin/nu
use std log
source ../../vm_vars.nu

def main [...args] {
	log info "Setting governors for VM_ON"
	let cpus = ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	for $cpu in $cpus {
		echo $env.VM_ON_GOVERNOR | save -f $cpu.name
	}
	powerprofilesctl set $env.VM_ON_PWRPROFILE
	log info "Set governors for VM_ON"
}
