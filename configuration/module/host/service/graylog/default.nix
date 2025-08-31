# Copies from nixpkgs but uses environment variable to set config
{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.graylog;

  mongodb_host = lib.network.serviceHandlerHost config "mongodb";
  mongodb_uri = "mongodb://${mongodb_host}/graylog";

  confFile = pkgs.writeText "graylog.conf" ''
    is_master = ${lib.boolToString cfg.isMaster}
    node_id_file = ${cfg.nodeIdFile}
    password_secret = ${cfg.passwordSecret}
    root_username = ${cfg.rootUsername}
    root_password_sha2 = ${cfg.rootPasswordSha2}
    elasticsearch_hosts = ${lib.concatStringsSep "," cfg.elasticsearchHosts}
    message_journal_dir = ${cfg.messageJournalDir}
    mongodb_uri = ${cfg.mongodbUri}
    plugin_dir = /var/lib/graylog/plugins
    data_dir = ${cfg.dataDir}

    ${cfg.extraConfig}
  '';

  glPlugins = pkgs.buildEnv {
    name = "graylog-plugins";
    paths = cfg.plugins;
  };

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.service.graylog = {
    enable = mkEnableOption "graylog";

    httpPort = mkOption {
      type = types.int;
      default = 9000;
      description = lib.mdDoc "Http interface port number";
    };

    user = mkOption {
      type = types.str;
      default = "graylog";
      description = lib.mdDoc "User account under which graylog runs";
    };

    package = lib.mkPackageOption pkgs "graylog" {
      example = "graylog-6_0";
    };

    isMaster = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether this is the master instance of your Graylog cluster";
    };

    nodeIdFile = mkOption {
      type = types.str;
      default = "/var/lib/graylog/server/node-id";
      description = lib.mdDoc "Path of the file containing the graylog node-id";
    };

    elasticsearchHosts = mkOption {
      type = types.listOf types.str;
      example = lib.literalExpression ''[ "http://node1:9200" "http://user:password@node2:19200" ]'';
      description = lib.mdDoc "List of valid URIs of the http ports of your elastic nodes. If one or more of your elasticsearch hosts require authentication, include the credentials in each node URI that requires authentication";
    };

    messageJournalDir = mkOption {
      type = types.str;
      default = "/var/lib/graylog/data/journal";
      description = lib.mdDoc "The directory which will be used to store the message journal. The directory must be exclusively used by Graylog and must not contain any other files than the ones created by Graylog itself";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc "Any other configuration options you might want to add";
    };

    plugins = mkOption {
      description = lib.mdDoc "Extra graylog plugins";
      default = [ ];
      type = types.listOf types.package;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."graylog/password_secret" = {
      owner = config.users.users.graylog.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."graylog/root_user_name" = {
      owner = config.users.users.graylog.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."graylog/root_password_hash" = {
      owner = config.users.users.graylog.name;
      sopsFile = config.sopsFiles.service;
    };

    sops.templates."graylog_env_file" = {
      content = ''
        GRAYLOG_PASSWORD_SECRET=${config.sops.placeholder."graylog/password_secret"}
        GRAYLOG_ROOT_USERNAME=${config.sops.placeholder."graylog/root_user_name"}
        GRAYLOG_ROOT_PASSWORD_SHA2=${config.sops.placeholder."graylog/root_password_hash"}
      '';
      owner = config.users.users.graylog.name;
    };

    users.users = mkIf (cfg.user == "graylog") {
      graylog = {
        isSystemUser = true;
        group = "graylog";
        description = "Graylog server daemon user";
      };
    };
    users.groups = mkIf (cfg.user == "graylog") { graylog = { }; };

    systemd.tmpfiles.rules = [
      "d '${cfg.messageJournalDir}' - ${cfg.user} - - -"
    ];

    systemd.services.graylog = {
      description = "Graylog Server";
      wantedBy = [ "multi-user.target" ];
      environment = {
        GRAYLOG_CONF = "${confFile}";
      };
      path = [
        pkgs.which
        pkgs.procps
      ];
      preStart = ''
        rm -rf /var/lib/graylog/plugins || true
        mkdir -p /var/lib/graylog/plugins -m 755

        mkdir -p "$(dirname ${cfg.nodeIdFile})"
        chown -R ${cfg.user} "$(dirname ${cfg.nodeIdFile})"

        for declarativeplugin in `ls ${glPlugins}/bin/`; do
          ln -sf ${glPlugins}/bin/$declarativeplugin /var/lib/graylog/plugins/$declarativeplugin
        done
        for includedplugin in `ls ${cfg.package}/plugin/`; do
          ln -s ${cfg.package}/plugin/$includedplugin /var/lib/graylog/plugins/$includedplugin || true
        done
      '';
      unitConfig = {
        Wants = [
          "elasticsearch.service"
          "mongodb.service"
        ];
      };
      serviceConfig = {
        User = "${cfg.user}";
        StateDirectory = "graylog";
        ExecStart = "${cfg.package}/bin/graylogctl run";
        EnvironmentFile = config.sops.templates."graylog_env_file".path;
      };
    };
  };
}
