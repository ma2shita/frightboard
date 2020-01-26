FrightBoard for Working dashboard
=================================

Working status dashboard SKELTON system.
CRUD operations by REST API and WEB Dashboard using (Semi-)Reactive.

No Authentication, No Data persistence, You gatta implement it!

_F"r"ight means "made by Ruby"_

Install and Run
---------------

Git clone and then run as below.

```
$ git clone https://github.com/ma2shita/frightboard.git CLONE_DIR
$ cd CLONE_DIR
$ bundle install
$ bundle exec rackup -p 5000
```

* Bundler's path can be specified. (e.g. `bundle config --local path vendor/bundle`)
* `DATABASE_URL` can be specified, use in-memory when not defined it. (e.g. `DATABASE_URL='sqlite://data.db'`)
* Can use `heroku local` instead of `rackup`.

### with PostgreSQL on local

```
$ sudo apt install postgresql-12 libpq-dev
$ sudo -u postgres /usr/lib/postgresql/12/bin/initdb -D db/
$ sudo -u postgres /usr/lib/postgresql/12/bin/postgres -D db/
```

```
$ DATABASE_URL='postgresql://postgres@localhost:5432' DB_VERSION=XXX bundle exec rake db:migrate:to
$ DATABASE_URL='postgresql://postgres@localhost:5432' bundle exec rackup -p 5000
```

Demonstration
-------------

Run on other terminal.

```
$ bundle exec rake demo:data
```

And then, see the dashboard page (http://localhost:5000)

[![Screencast](http://img.youtube.com/vi/M4cLtZjFKMA/0.jpg)](https://youtu.be/M4cLtZjFKMA)

Run
---

- App      : `bundle exec rackup`    (entrypoint is `config.ru`)
- Raketask : `bundle exec rake`      (entrypoint is `Rakefile`)
- Test     : `bundle exec rake spec` (entrypoint is `spec/spec_helper.rb`)

API Reference
=============

### `POST /api/v1/statuses` ###

New registration;

```
$ curl -X POST -d "status=running" "localhost:9292/api/v1/statuses?iid=pc01"
{"response":"created"}
```

Exists "pc01" (= update);

```
$ curl -X POST -d "status=completed" "localhost:9292/api/v1/statuses?iid=pc01"
{"response":"updated"}
```

Entry with Annotation (JSON format);

```
$ curl -X POST -d "status=pending" -d 'annotation={"comment":"pc of ma2shita"}' "localhost:9292/api/v1/statuses?iid=pc01"
{"response":"updated"}
```

### `GET /api/v1/statuses` ###

```
$ curl localhost:9292/api/v1/statuses
[
  {
    "iid": "pc01",
    "status": "completed",
    "created_at": "2015-11-10 00:08:28 +0900",
    "updated_at": "2015-11-10 00:10:11 +0900",
    "annotation": null
  },
  {
    "iid": "group/pc02",
    "status": "running",
    "created_at": "2015-11-10 00:40:03 +0900",
    "updated_at": "2015-11-10 00:49:43 +0900",
    "annotation": {
      "comment": "pc of ma2shita"
    }
  }
]
```

_formatted by jq_

### `DELETE /api/v1/statuses` ###

```
$ curl -X DELETE "localhost:9292/api/v1/statuses?iid=pc01"`
{"response":"accepted"}
```

License
-------

MIT


Deploy to Heroku
================

Init;

```
$ cd frightboard
$ heroku git:remote -a HEROKU_APP_NAME
$ heroku addons:create heroku-postgresql:hobby-dev [--version 12]
$ heroku config:add TZ=Asia/Tokyo
```

Deploy;

```
$ heroku git push heroku master
```

DB migrate;

```
(Deploy and then)
$ heroku config:set DB_VERSION=XXX
$ heroku run rake db:migrate:to
$ heroku restart
```


Inside of FrightBoard
=====================

Components;
-----------

Ruby;

* [Grape](https://github.com/ruby-grape/grape) : API
* [Sequel](http://sequel.jeremyevans.net) : DB connector & ORM
* [Sinatra](http://www.sinatrarb.com) : HTML serve
* [RSepc](http://rspec.info) : Testing

HTML and others;

* [Bootstrap](http://getbootstrap.com) : HTML/CSS/JS framework
* [Knockout](http://knockoutjs.com) : MVVM

EOT
