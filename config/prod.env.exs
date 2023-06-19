import Mix.Config
config :backend_stuff_api, port: 4000
config :backend_stuff_api, database: "backend_stuff_api_db"
config :backend_stuff_api, pool_size: 2
config :backend_stuff_api, :c, username: "user", password: "secret"

config :backend_stuff_api, :db_config,
  name: :mongo,
  url: "mongodb://mongodb:27017/backend_stuff_api_db"

# config :backend_stuff_api, mongo_url: "mongodb://mongodb:27017/backend_stuff_api_db"
# config :backend_stuff_api, rabbitmq_url: "amqp://guest:guest@rabbitmq:5672"

config :amqp,
  connections: [
    myconn: [url: "amqp://rabbit:rabbit@APILOT-AwWQ6pBk:12345"]
  ],
  channels: [
    mychan: [connection: :myconn]
  ]
