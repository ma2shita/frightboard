FrightBoard for Working dashboard
=================================

Working status dashboard SKELTON system.
CRUD operations by REST API and WEB Dashboard using Reactive.

No Authentication, No Data persistence, You gatta implement it!

_F"r"ight means "made by Ruby"_

Install
-------

Git clone and

```
$ bundle install [--path vendor/bundle]
```

Demonstration
-------------

Install and run as below;

```
$ bundle exec rackup
 and Other Terminal...
$ bundle exec demo:data
```

And see [Dashboard page](http://localhost:9292)

Run
---

- test     : `bundle exec rspec`  (entrypoint is `spec/spec_helper.rb`)
- App      : `bundle exec rackup` (entrypoint is `config.ru`)
- Raketask : `bundle exec rake`   (entrypoint is `Rakefile`)

APIs
----

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
