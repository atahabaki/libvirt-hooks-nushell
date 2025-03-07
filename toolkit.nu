const BASE_DIR = "/etc/libvirt/hooks/qemu.d/"
const HOOK_FILE = "/etc/libvirt/hooks/qemu"
const TOOLKIT_DIR = path self .
const MAIN_NU_FILE = [$TOOLKIT_DIR 'main.nu'] | path join

def "create qemu.d dir if does not exists" [] {
  if (not ($BASE_DIR | path exists)) {
    sudo mkdir -p $BASE_DIR
  }
}

def "install hook file" [force: bool] {
  if (($HOOK_FILE | path exists) and $force) {
    sudo rm -rf $HOOK_FILE
    sudo cp -f $MAIN_NU_FILE $HOOK_FILE
    sudo chmod +x $HOOK_FILE
    exit 0
  }
  sudo cp $MAIN_NU_FILE $HOOK_FILE
  sudo chmod +x $HOOK_FILE
}

export def install [
  --force
] {
  create qemu.d dir if does not exists
  install hook file $force
}
