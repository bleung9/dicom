Note: `docker compose` is used, not `docker-compose`.

See: https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command

## Setup
```
cp .env.example .env
docker compose build
docker compose run --rm web bin/rails db:setup
```

## Run the app
```
docker compose up
```


## Run tests
```
docker compose run --rm web bin/rspec
```
