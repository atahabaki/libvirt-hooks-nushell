#!/bin/nu

use std log
source ../../vm_vars.nu

log info "Releasing hugepages…"
echo 0 | save -f /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

let allocated = cat /proc/sys/vm/nr_hugepages | into int

if $allocated == 0 {
	log info "Hugepages successfully released!"
}
