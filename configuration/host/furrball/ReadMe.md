# Furrball - Looniversity Workstation

## Disk layout

3 * 1TB SSD

### Disk 1

Partitiions

1. partuuid = `ae404967-9818-47bb-bb8f-d6708bc3f26b`
   - uuid `018842cd-642f-46d6-b874-37b4dcdb5aec`
   - mountpoint = `/`
   - fs type = `ext4`
   - on disk = parition 2

1. partuuid = `4cb76b78-6f88-4473-bc36-52dd98b7e11c`
   - uuid `9E76-CA3B`
   - mountpoint = `/boot`
   - fs type = EFI System partition
   - on disk = parition 1

1. partuuid = `549fc9c1-17e9-4966-b629-55d5f79deaff`
   - uuid `14274885556233388955`
   - ZFS pool `tank0`
   - on disk = parition 3

### Disk 2 & 3

ZFS mirror pool `tank1`

## ZFS datasets

### tank0

#### `tank0/nix`

- mountpoint = `/nix`

#### `tank0/tmp`

- mountpoint = `/tmp`
- sync = disabled

#### `tank0/var`

- mountpoint = `/var`

### tank1

#### `tank1/home`

- mountpoint = `/home`
