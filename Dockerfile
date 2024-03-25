FROM hexpm/elixir:1.16.2-erlang-26.2.1-alpine-3.19.1 as base

RUN mkdir /app
WORKDIR /app

RUN apk --no-cache add g++ make git && mix local.hex --force && mix local.rebar --force

FROM base as test
COPY . /app

FROM base AS app_builder
ENV MIX_ENV=prod

# copy only deps-related files
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile
# at this point we should have a valid reusable built cache that only changes
# when either deps or config/{config,prod}.exs change

# COPY priv priv
COPY lib lib
COPY config/runtime.exs config/
# COPY rel rel # could contain rel/vm.args.eex, rel/remote.vm.args.eex, and rel/env.sh.eex
RUN mix release

FROM alpine:3.19.1 as app

RUN apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs

RUN adduser -D app
COPY --from=app_builder /app/_build .
RUN chown -R app:app /prod
USER app
CMD ["./prod/rel/dns302/bin/dns302", "start"]

