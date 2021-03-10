FROM ruby:2.7.2-alpine

# Upgrade packages
RUN apk --no-cache --update --available upgrade

RUN apk add --no-cache --update \
  && apk add build-base \
  git \
  postgresql-dev \
  postgresql-client \
  tzdata \
  curl bash

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . .

EXPOSE 3000

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD [ "rails", "server", "-b", "0.0.0.0" ]
