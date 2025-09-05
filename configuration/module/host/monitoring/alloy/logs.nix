{
  config,
  lib,
  pkgs,
  ...
}:
''
  loki.source.journal "local" {
    forward_to = [loki.write.looniversity.receiver]
  }
''
