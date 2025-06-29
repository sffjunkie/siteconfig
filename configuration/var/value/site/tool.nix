{
  config.looniversity.tools = {
    postgresql-admin = {
      module = "admin.postgresql";
      port = 5050;
    };
    mongodb-admin = {
      module = "admin.mongodb";
    };
    netbox = {
      port = 8001;
    };
  };
}
