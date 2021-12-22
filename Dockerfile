FROM ruby:2.4.10-slim-buster as rails
ENV DEBIAN_VERSION=buster

# Install general packages
ENV PACKAGES build-essential libpq-dev netcat git python-pip python-dev apt-utils wget unzip \
    lftp ssh jq gnupg apt-transport-https cron libgs-dev libsqlite3-dev libx11-6 \
    libx11-data libxau6 libxcb1 libxdmcp6 libxext6 libxi6 libxrender1 libxtst6 x11-common \
    ghostscript imagemagick graphviz shared-mime-info
RUN echo "Updating repos..." && \
    apt-get update > /dev/null && \
    echo "Installing packages: ${PACKAGES}..." && \
    apt-get install -y $PACKAGES --fix-missing --no-install-recommends > /dev/null && \
    echo "Done" && rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Configure/Install Postgres Repos/Deps
ENV PG_PACKAGES postgresql-11
# RUN apt update -y ca-certificates
RUN apt update && apt upgrade -y
RUN echo deb https://apt.postgresql.org/pub/repos/apt buster-pgdg main > /etc/apt/sources.list.d/buster-pgdg.list && \
    wget --debug -O - https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN echo "Updating repos..." && apt-get update > /dev/null && \
#    echo "Installing posgres packages: ${PG_PACKAGES}..." && \
#    apt-get install -y $PG_PACKAGES --fix-missing --no-install-recommends > /dev/null && \
    echo "Installing posgres packages: ${PG_PACKAGES}..." && \
    apt-get -t buster-pgdg install -y $PG_PACKAGES --fix-missing --no-install-recommends > /dev/null && \
    echo "Done." && rm -rf /var/lib/apt/lists/* && \
    apt-get clean

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN mkdir -p tmp/pids /var/log/rails /var/run/unicorn /var/run/resque /var/log/unicorn /var/log/resque

# MUST configure BUNDLE_GEMINABOX__SBA__ONE__NET before building with either:
#   when running `docker build`:         docker build --build-arg BUNDLE_GEMINABOX__SBA__ONE__NET=[license]
#   when running `docker-compose build`: export BUNDLE_GEMINABOX__SBA__ONE__NET=[license]
ARG BUNDLE_GEMINABOX__SBA__ONE__NET
RUN echo "Checking for mandatory build arguments..." && : "${BUNDLE_GEMINABOX__SBA__ONE__NET:?BUNDLE_GEMINABOX__SBA__ONE__NET Build argument needs to be set and non-empty.}"

# Update System gem and install bundler
RUN gem update --system 3.0.2
RUN gem install bundler --version 1.17
RUN gem install nokogiri -v 1.10.10
RUN gem install mimemagic -v 0.3.8
# Cache the bundle install
COPY Gemfile Gemfile.lock ./
RUN env "BUNDLE_GEMINABOX__SBA-ONE__NET=${BUNDLE_GEMINABOX__SBA__ONE__NET}" bundle install --jobs=4 --retry=3

COPY . .
COPY public/locale public/assets/locale

RUN echo "running assets:precompile, RAILS_ENV=${RAILS_ENV}" && RAILS_ENV=build bundle exec rake assets:precompile
ARG BUILD_VERSION
ARG MAJOR_VERSION
ARG MINOR_VERSION
ARG PATCH_VERSION
RUN echo "creating version file" && bundle exec rake create_version

# Set-up whenever-cron-jobs 
RUN mkdir -p tmp/pids /var/log/rails

# Setup Entrypoint
ENV RAILS_LOG_TO_STDOUT=true
RUN cp ./docker/entrypoint.sh ./docker/start-rails.sh ./docker/start-resque-worker.sh ./docker/start-resque-scheduler.sh ./docker/start-whenever-cron-jobs.sh /usr/bin/ && chmod 555 /usr/bin/entrypoint.sh /usr/bin/start-rails.sh /usr/bin/start-resque-worker.sh /usr/bin/start-resque-scheduler.sh /usr/bin/start-whenever-cron-jobs.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["start-rails.sh"]
EXPOSE 3000

