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

The two controllers that handle requests are in `app/controllers`. Saved images are found in `storage`.

There are various comments in the code that are relevant to the submission. Please read them.

This project uses a ruby gem called `dicom` to handle operations on DICOM images. This gem provides an interface to convert .dcm files to other formats, but it has a dependency on another ruby gem which failed to install. This may be due to an OS upgrade I did on my machine. The line of code that would otherwise do the format conversion is `app/controllers/images_controller.rb:34`. Currently, the GET `images` endpoint is loading a pre-saved file in the `storage` folder.

Tests are found in `spec/requests` and can be run w/ the above command.

The following Postman screenshots show how to use this app.

![POST images](https://i.imgur.com/JszXLSx.png)
![GET images](https://i.imgur.com/19PjaD2.png)
![GET attributes](https://i.imgur.com/BXBamqL.png)
