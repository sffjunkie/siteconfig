{
  config,
  lib,
  pkgs,
  ...
}:
''
  // Define which log files to collect for node_exporter
  local.file_match "logs_integrations_integrations_node_exporter_direct_scrape" {
    path_targets = [{
      __address__ = "localhost",
      __path__    = "/var/log/{syslog,messages,*.log}",
      instance    = constants.hostname,
      job         = "integrations/node_exporter",
    }]
  }

  // Collect logs from files for node_exporter
  loki.source.file "logs_integrations_integrations_node_exporter_direct_scrape" {
    targets    = local.file_match.logs_integrations_integrations_node_exporter_direct_scrape.targets
    forward_to = [loki.write.looniversity.receiver]
  }

  // Collect logs from systemd journal for node_exporter
  loki.source.journal "logs_integrations_integrations_node_exporter_journal_scrape" {
    max_age       = "24h0m0s"
    relabel_rules = discovery.relabel.logs_integrations_integrations_node_exporter_journal_scrape.rules
    forward_to    = [loki.write.looniversity.receiver]
  }

  // Define relabeling rules for systemd journal logs
  discovery.relabel "logs_integrations_integrations_node_exporter_journal_scrape" {
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
