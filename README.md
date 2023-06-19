# backend_stuff_api
 An Elixir Dockerized application that uses MongoDB and RabbitMQ

# Developing
After any change run `mix deps.get && mix deps.compile && mix compile`
!!!Remove Containers && their respective images in order to see the changes!!!
 # Deploy
 Run `docker-compose up`
 ## MongoDB GUI
Downlaod MongoDb Compass
Connect to : `mongodb://localhost:27017/backend_stuff_api_db`

## TODO
- Configure RabbitMQ to receive messages
- Configure first CRUD
- Merge Auth previous Repo
- Email Notification
- Statistics