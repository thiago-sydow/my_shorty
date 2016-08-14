# My Shorty

[![Build Status](https://travis-ci.org/thiago-sydow/my_shorty.svg?branch=master)](https://travis-ci.org/thiago-sydow/my_shorty)
[![Code Climate](https://codeclimate.com/github/thiago-sydow/my_shorty/badges/gpa.svg)](https://codeclimate.com/github/thiago-sydow/my_shorty)
[![Test Coverage](https://codeclimate.com/github/thiago-sydow/my_shorty/badges/coverage.svg)](https://codeclimate.com/github/thiago-sydow/my_shorty/coverage)

## Install
The following commands will install git and some packages necessary to build ruby and gems:

```sh
sudo apt-get update

sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev redis-server
```

Installing ruby with RVM:

```
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.3.1
rvm use 2.3.1 --default
gem install bundler
```

Make sure Redis is running:
```
sudo service redis-server start
```

## Running locally
```
$ git clone git@github.com:thiago-sydow/my_shorty.git
$ cd my_shorty/
$ bundle install
$ bundle exec thin start
```

The app will be running at `http://localhost:3000`

## Running Tests
```
$ bundle exec rake
```

## Changing databases
To change database (development, production) you just have to register a different type  of Repository for the key `:short_code` in config/environment.rb

Example:

Current config for development
```
configure :development do
  RepositoryRegister.register(:short_code, RedisRepository.new)
end
```

Changed to use InMemory store
```
configure :development do
  RepositoryRegister.register(:short_code, InMemoryRepository.new)
end
```

To change Spec database you have to change the same, but in `spec_helper.rb` file.

I found this way cool and easy to implement others databases. Implement in MongoDB would be very easy (SQL databases would require some thinking though, schema/migrations etc..)
