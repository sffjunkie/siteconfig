# Babs - Looniversity Storage

## Disk layout

- 1TB SSD boot drive
- 4 * 1TB HD - ZFS
- 4 * 1.5TB HD - ZFS
- 4 * 3TB HD - ZFS
- 1 * 64GB - ZFS ARC

### Disk 1

Type = 1TB SSD

Partitions

1. partuuid = `01e0f4ad-4043-c34b-9e24-1a02b123c1b9`
   - mountpoint = `/`
   - fs type = `ext4`
   - on disk = parition 2

1. partuuid = `b777f8bc-1be5-bb41-8631-299ec100f3f3`
   - uuid `519C-6981`
   - mountpoint = `/boot`
   - fs type = EFI System partition
   - on disk = parition 1

### ZFS pools

#### tank0

- tank0/audiobooks
- tank0/ebooks
- tank0/iso
- tank0/music
- tank0/photos
- tank0/pictures
- tank0/sync

#### tank1

- tank1/comedy
- tank1/exercise
- tank1/kids
- tank1/movies
- tank1/music_videos
- tank1/radio
- tank1/roms
- tank1/torrent
- tank1/tv_shows

`/home`

## NFS Exports

- /tank0/audiobooks
- /tank0/ebooks
- /tank0/iso
- /tank0/music
- /tank0/photos
- /tank0/pictures
- /tank1/comedy
- /tank1/exercise
- /tank1/kids
- /tank1/movies
- /tank1/music_videos
- /tank1/private
- /tank1/radio
- /tank1/roms
- /tank1/torrent
- /tank1/tv_shows

## Services

- minio
- nfs
- samba

To Do

- syncthing
- attic
