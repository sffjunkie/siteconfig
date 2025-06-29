{ lib, ... }:
let
  # getToolModule :: attrSet -> str -> str
  # Gets a hosts network device given an alias
  getToolModule = config: toolName: config.looniversity.tools.${toolName}.module;

  # getToolPort :: attrSet -> str -> int
  getToolPort = config: toolName: config.looniversity.tools.${toolName}.port;
in
{
  inherit getToolModule getToolPort;
}
