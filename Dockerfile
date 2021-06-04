FROM elixir:1.12.1
RUN apt-get update && \
        apt-get install -y \
        inotify-tools npm

RUN mix local.hex --force && \
  mix local.rebar --force

RUN mkdir /usr/src/tmfsz

WORKDIR /usr/src/tmfsz

COPY mix.exs /usr/src/tmfsz/mix.exs
COPY mix.lock /usr/src/tmfsz/mix.lock

RUN mix do deps.get, deps.compile
RUN npm install
