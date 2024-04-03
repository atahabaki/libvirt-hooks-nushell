#!/bin/nu
# How much memory we've assigned to the VM, in kibibytes 
$env.VM_MEMORY = 1259520

# Set the governor to use when the VM is on.
$env.VM_ON_GOVERNOR = performance
# Set the governor to use when the VM is off.
$env.VM_OFF_GOVERNOR = powersave

# Set the powerprofilesctl profile to use when the VM is on.
$env.VM_ON_PWRPROFILE = performance
# Set the powerprofilesctl profile to use when the VM is off.
$env.VM_OFF_PWRPROFILE = power-saver

# Set which CPU to isolate for VM.
$env.VM_ISOLATED_CPUS = "0-7"
# Set which CPUs to return.
$env.SYS_TOTAL_CPUS = "0-15"
