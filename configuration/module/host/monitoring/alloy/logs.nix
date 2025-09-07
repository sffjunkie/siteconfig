{
  config,
  lib,
  pkgs,
  node,
  ...
}:
''
  // Define which log files to collect for node_exporter
  local.file_match "${node}_log" {
    path_targets = [{
      __address__ = "localhost",
      __path__    = "/var/log/{syslog,messages,*.log}",
      instance    = constants.hostname,
      job         = "integrations/node_exporter",
    }]
  }

  // Collect logs from files for node_exporter
  loki.source.file "${node}_log" {
    targets    = local.file_match.${node}_log.targets
    forward_to = [loki.write.looniversity.receiver]
  }

  // Collect logs from systemd journal for node_exporter
  loki.source.journal "${node}_journal" {
    max_age       = "24h0m0s"
    relabel_rules = discovery.relabel.${node}_journal.rules
    forward_to    = [loki.write.looniversity.receiver]
  }

  // Define relabeling rules for systemd journal logs
  discovery.relabel "${node}_journal" {
    targets = []

    rule {
      source_labels = ["__journal__systemd_unit"]
      target_label  = "unit"
    }

    rule {
      source_labels = ["__journal__boot_id"]
      target_label  = "boot_id"
    }

    rule {
      source_labels = ["__journal__transport"]
      target_label  = "transport"
    }

    rule {
      source_labels = ["__journal_priority_keyword"]
      target_label  = "level"
    }
  }
''
