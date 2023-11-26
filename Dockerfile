FROM ruby:2.5-alpine

RUN apk add --update --no-cache \
      ca-certificates \
      linux-headers \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      gmp-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      sqlite-dev \
      socat \
      mariadb-dev \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \
      yarn

WORKDIR /app
RUN gem install bundler \
    && bundler config --global frozen 1

RUN bundle config --global frozen 1
# RUN bundle config build.nokogiri --use-system-libraries

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]