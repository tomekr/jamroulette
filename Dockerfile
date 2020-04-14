FROM ruby:2.6.6

ENV NODE_VERSION 12.8.1
ENV BUNDLER_VERSION 2.1.4

# Add yarn debian source to apt
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Add chrome debian source to apt
RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

# Install Chromedriver
RUN wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/bin && \
    chmod u+x /usr/bin/chromedriver

# Install nodejs
RUN curl -sSLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" && \
    tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1

RUN apt-get update -qq && apt-get install -y postgresql-client yarn google-chrome-stable cmake && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
RUN gem install bundler -v $BUNDLER_VERSION

RUN mkdir /app
WORKDIR /app

# Install standard gems
COPY Gemfile* /app/
RUN bundle config set without 'production' && \
    bundle install --jobs 4

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app

RUN bundle exec rails assets:precompile
