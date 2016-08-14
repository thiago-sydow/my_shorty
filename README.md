# My Shorty

[![Build Status](https://travis-ci.org/thiago-sydow/my_shorty.svg?branch=master)](https://travis-ci.org/thiago-sydow/my_shorty)
[![Code Climate](https://codeclimate.com/github/thiago-sydow/my_shorty/badges/gpa.svg)](https://codeclimate.com/github/thiago-sydow/my_shorty)
[![Test Coverage](https://codeclimate.com/github/thiago-sydow/my_shorty/badges/coverage.svg)](https://codeclimate.com/github/thiago-sydow/my_shorty/coverage)

My Shorty is a simple url shortner service, available in Heroku at https://rocky-hamlet-97078.herokuapp.com

The documentation of the API is available here: http://docs.myshorty.apiary.io

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

## Quick Benchmark
Just for fun, I ran [wrk](https://github.com/wg/wrk) to see how the app behaves.

With 100 concurrent users, during 30s of load...

For creation of shortcode:
 
```
wrk -t100 -c100 -d30s https://rocky-hamlet-97078.herokuapp.com/shorten -s ~/post_lua_wrk.lua
Running 30s test @ https://rocky-hamlet-97078.herokuapp.com/shorten
  100 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   296.29ms   82.06ms   1.30s    94.21%
    Req/Sec     3.33      1.03     5.00     67.49%
  9782 requests in 30.06s, 2.07MB read
  Socket errors: connect 0, read 0, write 0, timeout 1
Requests/sec:    325.46
Transfer/sec:     70.55KB
```

Redirect to Google:

```
wrk -t100 -c100 -d30s https://rocky-hamlet-97078.herokuapp.com/shorttogoogle
Running 30s test @ https://rocky-hamlet-97078.herokuapp.com/shorttogoogle
  100 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   314.79ms   74.44ms   1.49s    86.25%
    Req/Sec     3.08      1.06     5.00     57.49%
  8878 requests in 30.09s, 2.60MB read
Requests/sec:    295.09
Transfer/sec:     88.47KB
```

Stats for `shorttogoogle`:

```
wrk -t100 -c100 -d30s https://rocky-hamlet-97078.herokuapp.com/shorttogoogle/stats
Running 30s test @ https://rocky-hamlet-97078.herokuapp.com/shorttogoogle/stats
  100 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   307.33ms   74.39ms 963.90ms   86.63%
    Req/Sec     3.18      1.12     5.00     54.66%
  9245 requests in 30.07s, 2.65MB read
Requests/sec:    307.41
Transfer/sec:     90.36KB
```
