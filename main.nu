#!/usr/bin/env nu

def __log_modes [] { [info warn err] }

def log [mode: string@__log_modes, message: string] {
  let log_file = [$env.FILE_PWD log.txt] | path join
  mut _ansi_mode = 0
  if ($mode == "err") {
    $_ansi_mode = ansi red_bold
  } else if ($mode == "warn") {
    $_ansi_mode = ansi yellow_bold
  } else {
    $_ansi_mode = ansi blue_bold
  }
  echo $"($_ansi_mode)(date now | format date '%s') | ($mode | str upcase):(ansi reset) ($message)\n" | save -af $log_file
}

def "check default dir exists or not" [] {
  let default_dir = [$env.FILE_PWD default] | path join
  if ($default_dir | path exists) {
    log info $"default dir exists at ($default_dir)"
  } else {
    log warn "default dir does not exist, install it."
  }
}

def "check hooks disabled or not" []: string -> bool {
  (($in | str ends-with "-woh") or
    ($in | str ends-with "-without-hooks") or
    ($in | str ends-with "-nh") or
    ($in | str ends-with "-no-hooks"))
}

def "check default hooks disabled or not" []: string -> bool {
  (($in | str ends-with "-nd") or
    ($in | str ends-with "-no-default") or
    ($in | str ends-with "-wod") or
    ($in | str ends-with "-without-default"))
}

def "executing order" [guest_dir: string, hook: string, state: string, ...rest] {
  let hook_dir = $guest_dir | path join $hook
  if ($hook_dir | path exists) {
    log info "Hook dir found."
    if (($hook_dir | path type) == "file") {
      log info "Hook file found, executing it."
      nu $hook_dir $state ...($rest)
      exit 0
    }
    let state_dir = $hook_dir | path join $state
    if ($state_dir | path exists) {
      log info "State dir found."
      if (($state_dir | path type) == "file") {
        log info "State file found, executing it."
        nu $state_dir ...($rest)
        exit 0
      } else {
        ls $state_dir | sort -i | each {|file| 
          log info $"Executing ($file)"
          nu $file.name ...($rest)
        }
      }
    } else {
      log err "State dir not found."
      exit -1
    }
  } else {
    log err "Hook dir not found."
    exit -1
  }
}

def main [...args] {
  let guest = $args | get -i 0
  let hook = $args | get -i 1
  let state = $args | get -i 2
  let rest = $args | slice 3..
  check default dir exists or not
  if ($guest | check hooks disabled or not) {
    log info $"($guest), caught str ends-with! Hooks disabled for this guest, terminating."
    exit 0
  }
  mut skip_default_hooks = false
  if ($guest | check default hooks disabled or not) {
    log info $"($guest), caught str ends-with! Default hooks skipped."
    $skip_default_hooks = true
  }
  let qemu_d = [$env.FILE_PWD 'qemu.d'] | path join
  if ($qemu_d | path exists) {
    log info "qemu.d dir exists."
    let guest_dir = $qemu_d | path join $guest
    if ($guest_dir | path exists) {
      log info "Guest dir exists."
      if (($guest_dir | path type) == "file") {
        log info "Executing guest hook file"
        nu $guest_dir $hook $state ...($rest)
        exit 0
      }
      executing order $guest_dir $hook $state ...($rest)
    } else {
      if $skip_default_hooks {
        log warn "-nd/-wod & no guest-hook dir found. Terminating."
        exit 0
      } else {
        let default_dir = [$qemu_d 'default'] | path join
        if ($default_dir | path exists) {
          log info "no guest-hook dir found, gonna executing defaults"
          if (($default_dir | path type) == "file") {
            log info "Executing guest hook file"
            nu $default_dir $hook $state ...($rest)
            exit 0
          }
          executing order $default_dir $hook $state ...($rest)
        } else {
          log err "guest-hook dir not found, even default dir not found."
          log err "Please install this tool, correctly."
          exit -1
        }
      }
    }
  } else {
    log err "qemu.d dir does not exist. Please install libvirt-hooks-nushell correctly."
    exit -1
  }

}
