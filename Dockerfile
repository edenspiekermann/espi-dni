FROM elixir:1.3

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get update && apt-get install -y \
  nodejs \
  inotify-tools

RUN mkdir /app
WORKDIR /app

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
CMD ["mix", "phoenix.server"]
