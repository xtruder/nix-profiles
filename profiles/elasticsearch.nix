{ config, lib, pkgs, ... }: with lib; {
  options.profiles.elasticsearch = {
    enable = mkEnableOption "Whether to enable elasticsearch profile.";
  };

  config = mkIf config.profiles.elasticsearch.enable {
    services = {
      elasticsearch.enable = true;
      elasticsearch.plugins = [ pkgs.elasticsearchPlugins.elasticsearch_kopf ];
    };
  };
}
