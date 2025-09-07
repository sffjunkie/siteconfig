{
  config = {
    services.prometheus.scrapeConfigs = [
      # Scrape pfsense stats
      {
        job_name = "pfsense";
        scrape_interval = "5s";
        static_configs = [
          {
            targets = [ "10.44.0.1:9100" ];
          }
        ];
      }
    ];
  };
}
