#!/usr/bin/nu
use std log
source ../../vm_vars.nu

def main [...args] {
	log info "Calculating wanted_size…"
	let hugepage_size = rg Hugepagesize /proc/meminfo | awk '{print $2}' | into int
	let wanted_size = $env.VM_MEMORY / $hugepage_size

	mut try_count = 0
	loop {
		try_allocate $wanted_size false
		let allocated_size = cat /proc/sys/vm/nr_hugepages | into int
		if $wanted_size == $allocated_size {
			log info "Finished allocating!"
			break
		} else {
			log error "Not enough, reallocating…"
			try_allocate $wanted_size true
		}
	}
}

def try_allocate [wanted_size: int, retry: bool] {
	if $retry {
		log debug "Defragging RAM…"
		echo 1 | save -f /proc/sys/vm/compact_memory
	}
	log info $"Trying to allocate ($wanted_size)…"
	echo $wanted_size | save -f /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
}

