# Edenspiekermann Goole DNI project

[ ![Codeship Status for edenspiekermann/espi_dni](https://codeship.com/projects/1b91ad70-4acf-0134-f11c-26219e586aaf/status)](https://codeship.com/projects/169763)

## Project Aim

The aim of the project is to build a tool to assist journalists by tracking article analytics and providing helpful information based on the article performance.

## How it works

The tool is being implemented as a Slackbot and uses integration with Google Analytics to track article performance.

The user flow is as follows:

1) A user adds the slackbot to their Slack account using the Slack Button and by completing the OAuth integration.

2) The user then grants the application access to Google Analytics using Google's OAuth integration.

3) The user selects the appropriate Google Analytics web property.

4) Once the Slack and Google integrations are setup the `/add` slack slash command will be available. A new article can be added using the slash command.

5) Once the article is confirmed, the application will track the article using the Google Analytics Realtime API

6) The slackbot will send the user a message if the analytics show a large increase or decrease in article traffic.

## Development Setup

### Prerequisites

The app is built using:

* Elixir 1.3
* Phoenix 1.2
* PostgreSQL 9.4

#### Homebrew

Homebrew is a package manger for OSX, we'll use this install `node` and `elixir`.

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### Elixir

Install Elixir via Homebrew

```
brew install elixir
```

#### Postgresql

Install PostgreSQL using the [Postgres.app](http://postgresapp.com)

#### Node.js

Install noedejs via Homebrew

```
brew install nodejs
```

### Setup

* Clone the repo
* Copy the `dev.secret.exs.sample` file to `dev.secret.ext` and add the appropriate values
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Install Node.js dependencies with `npm install`

### Running the App

To start the app locally:

Start Phoenix endpoint with `mix phoenix.server.` Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
