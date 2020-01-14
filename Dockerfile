FROM elixir:1.9.4
MAINTAINER Gustavo Ziaugra (gustavo.ziaugra@live.com)

RUN apt-get update && \
  apt-get install -f -y postgresql-client

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

RUN mix local.rebar --force

EXPOSE 4000

# Compile the project
RUN mix do compile
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]
