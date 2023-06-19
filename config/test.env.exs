import Config

config :backend_stuff_api, port: 4000
config :backend_stuff_api, database: "backend_stuff_api_db"
config :backend_stuff_api, pool_size: 2
config :backend_stuff_api, :basic_auth, username: "user", password: "secret"

config :amqp,
  connections: [
    myconn: [url: "amqp://rabbit:rabbit@APILOT-AwWQ6pBk:12345"]
  ],
  channels: [
    mychan: [connection: :myconn]
  ]
