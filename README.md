# LibreCov

![Build Status](https://github.com/yknx4/librecov/actions/workflows/tests.yml/badge.svg)
[![Coverage Status](https://www.librecov.com/projects/1/badge.svg)](https://www.librecov.com/projects/1)
[![codecov](https://codecov.io/gh/yknx4/librecov/branch/main/graph/badge.svg?token=Q9kaFXoFTn)](https://codecov.io/gh/yknx4/librecov)
[![codebeat badge](https://codebeat.co/badges/c1031e2a-2da1-4bd3-9654-26999b8c6478)](https://codebeat.co/projects/github-com-yknx4-librecov-main)

LibreCov is a self-hosted opensource test coverage history viewer.
It is (mostly) compatible with [coveralls](https://coveralls.io/), so most
coverage tools will work easily.

### Projects list

![projects](https://cloud.githubusercontent.com/assets/1436271/21740030/45ce95d6-d4ef-11e6-8d09-fac4aa7d5f00.png)

### Project page

![project page](https://cloud.githubusercontent.com/assets/1436271/21740031/45d0bafa-d4ef-11e6-93dc-0decbbd1d973.png)

### Build page

![build page](https://cloud.githubusercontent.com/assets/1436271/21740029/45cd825e-d4ef-11e6-9a55-ab19be6a3690.png)

### Coverage page

![coverage page](https://cloud.githubusercontent.com/assets/1436271/21740028/45cca55a-d4ef-11e6-9515-6b8672549dbd.png)

### Admin panel

![admin panel](https://cloud.githubusercontent.com/assets/1436271/21740375/adaaaa08-d4fb-11e6-916b-439a2eaeeb3b.png)

## Deploying the application

### Configuring

First, you will need to at least setup a database
To configure the app, create a `local.exs` file and override the configuration you need.
Check [config/local.sample.exs](https://github.com/yknx4/librecov/blob/main/config/local.sample.exs) to see the available configurations.

### Using docker

#### With an existing database

If you already have a database to use, you can simply start the application using docker:

Setup database, run migrations and seeds

```
docker run --rm -v /absolute/path/to/local.exs:/librecov/config/local.exs yknx4/librecov mix ecto.setup
```

Execute Phoenix Server

```
docker run -v /absolute/path/to/local.exs:/librecov/config/local.exs yknx4/librecov
```

This will start the server on the port you set in `local.exs`.

#### With docker-compose

If you do not have a database, you can start one with `docker` and `docker-compose`. See [docker-compose.yml](https://github.com/yknx4/librecov/blob/main/docker-compose.yml) for a sample `docker-compose.yml` file.

Once you have your `docker-compose.yml` and `local.exs` ready, you can run

```
docker-compose run librecov mix ecto.setup
docker-compose up
```

### Manually

```
git clone https://github.com/yknx4/librecov.git
cd librecov
cp /path/to/local.exs config/local.exs # local.exs must be in the `config` directory of the app

npm install # (or yarn install)
mix deps.get
mix ecto.setup
mix phoenix.server
```

This should start LibreCov at port 4000.

If you want to setup the server for production, you will need to run the above commands
with `MIX_ENV=prod` and to run

```
mix assets.compile
```

before starting the server.

### Deploying to Heroku

You should also be able to deploy to Heroku by simply git pushing this repository.
You will need to set the following environment variables using `heroku config:set`

- `LIBRECOV_PORT`
- `LIBRECOV_SCHEME`
- `SECRET_KEY_BASE`
- `SMTP_USER`
- `SMTP_PASSWORD`

You will need to run

```
heroku run mix ecto.setup
```

before you can use your application.

### Default user

In all setups, `mix ecto.setup` creates the following admin user

- email: admin@example.com
- password: p4ssw0rd

You should use it for your first login and the change the email and password.

## Sending test metrics

A few languages are documented in [the wiki](https://github.com/yknx4/librecov/wiki).
For other languages, coveralls instructions should work out of the box,
you just need to set the URL to your LibreCov server and to explicitly set
the token, even when using Travis.

## Development status

The application is more or less stable. I have been using it
for a little while now with coverage data from the 4 languages in the Wiki.

The main missing feature is the ability to send coverage status on pull requests.
The implementation is started in the [integrations branch](https://github.com/yknx4/librecov/tree/integrations) but I could not find the time to finish it yet.

I am open to any other suggestions, and help is very welcome.
