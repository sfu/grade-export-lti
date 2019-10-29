FROM instructure/ruby-passenger:2.6

WORKDIR /tmp
USER root
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  printf 'path-exclude /usr/share/doc/*\npath-exclude /usr/share/man/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc && \
  apt-get update -qq && \
  apt-get install -qqy zip nodejs && \
  curl -sSLO https://www.sqlite.org/2019/sqlite-amalgamation-3300100.zip && \
  unzip -qq sqlite-amalgamation-3300100.zip && \
  cd sqlite-amalgamation-3300100 && \
  gcc shell.c sqlite3.c -lpthread -ldl -o sqlite3 && \
  mv sqlite3 /usr/local/bin && \
  cd /tmp && rm -rf sqlite-amalgamation* && \
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* && \
  mkdir /bundle && \
  chown -R docker: /bundle /usr/src/app

USER docker
WORKDIR /usr/src/app
COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install -j 20
COPY . .

USER root
RUN chown -R docker: /bundle /usr/src/app

USER docker