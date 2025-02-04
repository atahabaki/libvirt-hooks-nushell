# Libvirt Hooks via Nu

Strengthen Your Virtual Machine Workflow with Libvirt Hooks.

## What are Libvirt Hooks?

Libvirt hooks are scripts that Libvirt triggers based on VM states. Dive deeper at
[Libvirt Hooks Documentation](https://libvirt.org/hooks.html).

### Enhance Your VM Experience

Imagine seamlessly transitioning into gaming nirvana. Your Gaming VM awakens, guided
by your pre-configured Libvirt hooks, acting like loyal minions fulfilling your every
command. They vanquish distractions, summon OBS Studio for flawless streaming, and set
the ambiance with subtle lighting adjustments. It's automation excellence in action.

## Installation

Get started with a straightforward installation process.

```nu
git clone https://atahabaki/libvirt-hooks-nushell
cd libvirt-hooks-nushell
sudo just install
```

## Usage

This README, purely focuses on the qemu hook. Other hooks basically the same, so please take 
a look at their documentation, [here](https://libvirt.org/hooks.html).

According to the official documentation, valid QEMU hook states include:

- *guest_name*/prepare/begin
- *guest_name*/start/begin
- *guest_name*/release/end

### Example Scenario

Suppose you're on a gaming laptop with a discrete GPU. You want to pass the dGPU to a VM.
Start by killing processes using the dGPU in the `/prepare/begin` state.

Navigate to the VM's hook directory, e.g., `/etc/libvirt/hooks/qemu.d/win10`:

```nu
cd /etc/libvirt/hooks/qemu.d/win10
```

Create a file `00-kill-dgpu-processes.nu` in `prepare/begin`:

```nu
touch ./prepare/begin/00-kill-dgpu-processes.nu
```

You can customize this script as needed. Similarly, for other VM states, create corresponding
nushell scripts for automation.

### Advanced Techniques

#### Default Hooks

If you frequently create similar VMs with identical hook requirements, simplify with a default
hooks folder. These hooks will apply by default to all VMs unless specified otherwise.
To exclude hooks entirely, name your VMs ending with `-woh` or `-no-hook`, e.g., `win10-gaming-woh`.

#### Pure State Files

If you do not want to create seperate files for each action,
(e.g., `00-kill-dgpu-processes`, `01-create-hugepages`...)
just create a file with that state name, (e.g., `prepare/begin`, `release/end`...).
And even further, you can just rewrite the hook file
(they are inside the `/etc/libvirt/hooks/` folder), (e.g., `qemu`, `lxc`...)

Unlock the full potential of your VM workflow with Libvirt hooks via NuShell!
