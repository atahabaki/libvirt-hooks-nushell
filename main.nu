#!/bin/nu
def main [...args] {
	let $guest = $args.0
	let $hook = $args.1
	let $state = $args.2
	let $misc_args = $args | skip 3
	let $basedir = $env.FILE_PWD
	let $filename = $env.CURRENT_FILE | path split | last
	let $confdir = $"($filename).d"
	mut $guest_path = ([$basedir $confdir $guest] | path join)
	mut $state_path = ([$guest_path $hook $state] | path join)
	use std log;
	let $ellipsis = (char --unicode '2026')
	if ($guest | str ends-with "-no-hook") or ($guest | str ends-with "-woh") {
		log info "Skipping libvirt hooks($ellipsis)"
		log debug "Reason: guest name has no/without hook flag."
	}	else {
		log info $"Using libvirt hooks($ellipsis)"
		if ($guest_path | path exists -n) {
			log debug $"($guest_path) exists."
			log debug $"Using existing hooks($ellipsis)"
		} else {
			log error $"($guest_path) does not exist."
			log warning $"Using default hooks($ellipsis)"
			$guest_path = ([$basedir $confdir 'default'] | path join)
			$state_path = ([$guest_path $hook $state] | path join)
		}
		if ($state_path | path exists -n) {
			log debug $"($state_path) exists."
			if (($state_path | path type) == "file") {
				log debug $"($state_path) is a file. Executing($ellipsis)"
					nu $state_path ...($misc_args)
			} else if (($state_path | path type) == "dir") {
				log debug $"($state_path) is a directory. Traversin($ellipsis)"
				let $files = glob $"($state_path)/*.nu" | sort
				for $file in $files {
					log debug $"($file) is running($ellipsis)"
					nu $file ...($misc_args)
				}
			}
		} else {
			log error $"($state_path) does not exist."
			log warning $"Skipping the hook named '(['default' $hook $state] | path join)'($ellipsis)"
		}
	}
}
