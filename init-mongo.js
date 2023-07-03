db = db.getSiblingDB("backend_stuff_api_db");
db.createCollection("dreams");
db.createCollection("users");

db.createCollection("comments");
db.createUser({
  user: "root",
  pwd: "example",
  roles: [{ role: "dbOwner", db: "backend_stuff_api_db" }],
});
