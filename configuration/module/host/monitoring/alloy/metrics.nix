{
  config,
  lib,
  pkgs,
  node ? "unknown",
  ...
}:
''
  // Configure the node_exporter integration to collect system metrics
  prometheus.exporter.unix "${node}_node_exporter" {
    // Disable unnecessary collectors to reduce overhead
    disable_collectors = ["ipvs", "btrfs", "infiniband", "xfs", "zfs"]
    enable_collectors = ["meminfo"]

    filesystem {
      // Exclude filesystem types that aren't relevant for monitoring
      fs_types_exclude     = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"
      // Exclude mount points that aren't relevant for monitoring
      mount_points_exclude = "^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+)($|/)"
      // Timeout for filesystem operations
      mount_timeout        = "5s"
    }

    netclass {
      // Ignore virtual and container network interfaces
      ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$"
    }

    netdev {
      // Exclude virtual and container network interfaces from device metrics
      device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$"
    }
  }

  // This block relabels metrics coming from node_exporter to add standard labels
  discovery.relabel "${node}_node_exporter" {
    targets = prometheus.exporter.unix.${node}_node_exporter.targets

    rule {
      target_label = "instance"
      replacement  = constants.hostname
    }

    rule {
      target_label = "job"
      replacement = "integrations/node_exporter"
    }
  }

  // Define how to scrape metrics from the node_exporter
  prometheus.scrape "${node}_node_exporter" {
    scrape_interval = "15s"
    targets    = discovery.relabel.${node}_node_exporter.output
    forward_to = [prometheus.remote_write.looniversity.receiver]
  }
''
