---
layout: post
title: Building a RESTful API with Sinatra
---

### Sinatra

[Sinatra](http://www.sinatrarb.com/) is a ruby gem that makes creating web applications very easy. Sinatra is essentially a DSL wrapped around ruby that aims to make [RESTful web services](http://en.wikipedia.org/wiki/Representational_state_transfer#RESTful_web_services) very easy to integrate into simple web services.

Taken from [Sinatra's github README](https://github.com/sinatra/sinatra/), here are some basic examples of routing RESTful web service calls such as GET, POST, PUT, and DELETE using Sinatra:

{% highlight ruby %}
# myapp.rb
require 'sinatra'

get '/' do
  'Hello world!'
end

post '/' do
  .. create something ..
end

put '/' do
  .. replace something ..
end

delete '/' do
  .. annihilate something ..
end
{% endhighlight %}

For this project I'll be using [ActiveRecord](http://rubydoc.info/gems/activerecord/3.2.11/frames), a robust ORM generally found in Ruby on Rails along with Sinatra. ActiveRecord will be used to change objects in the web service's underlying database in response to RESTful calls.

### The domain

This RESTful web service will be used to keep track of a collection of `Color`s. 

A `Color`:
- has a name (`Red`)
- has a description (`sort of a lightish blood color`)
- has a value which will be defined as a hex string (`#FF0000`)

### ActiveRecord code

First, we need to create the database that will be used to store `Color`s. Fortunately, we can use ActiveRecord to generate the database. In the code below, each of the attributes that will be a part of the `Color` object, as well as the type of each attribute (which are all `string` in this case) are defined. This code will be run once to create a table for `Color` models.

{% render_gist https://gist.github.com/raw/4470596/0f6131f8d207d67f785ce457a338c703cf4d7d4d/create-tables.rb %}

Next is the `Color` model, defined in `color.rb`. As a very simple model, a `Color` does not need to define any attributes. The `ActiveRecord::Base` class that `Color` extends will provide all of the model attributes to the Sinatra application, determining them from the database schema. This makes the `Color` class laughably simple.

{% render_gist https://gist.github.com/raw/4470596/95810d014da8592b90cf946814394771c1281af0/color.rb %}

### Sinatra code

Finally, the Sinatra application that uses ActiveRecord to communicate with the database:

{% render_gist https://gist.github.com/raw/4470596/b232118ecfb310a535f4f466aa6c413256211efa/server.rb %}

### Examples

Below are demonstrations of how the Sinatra application above responds to RESTful calls.

Create and view colors
{% highlight bash %}
# Create a Red color
curl -X POST localhost:4567/color --data "name=Red&description=A sort of lightish blood color&value=#FF0000"
# Create a Orange color
curl -X POST localhost:4567/color --data "name=Orange&description=The color of the sky, at dusk, maybe&value=#FC6B00"

curl -X GET localhost:4567/colors
# [
#  {"color":"#FF0000","description":"A sort of lightish blood color","id":1,"name":"Red"},
#  {"color":"#FC6B00","description":"The color of the sky, at dusk, maybe","id":2,"name":"Orange"}
# ]
{% endhighlight %}

View a single color
{% highlight bash %}
curl -X GET localhost:4567/color/2
# {"color":"#FC6B00","description":"The color of the sky, at dusk, maybe","id":2,"name":"Orange"}
{% endhighlight %}

Change a color
{% highlight bash %}
curl -X PUT localhost:4567/color/2 --data "description=The color of an orange"

curl -X GET localhost:4567/colors
# [
#  {"color":"#FF0000","description":"A sort of lightish blood color","id":1,"name":"Red"},
#  {"color":"#FC6B00","description":"The color of an orange","id":2,"name":"Orange"}
# ]
{% endhighlight %}

Remove a color
{% highlight bash %}
curl -X DELETE localhost:4567/color/1

curl -X GET localhost:4567/colors
# [{"color":"#FC6B00","description":"The color of the sky, at dusk, maybe","id":2,"name":"The color of an orange"}]
{% endhighlight %}

### Wrap up

Sinatra and ActiveRecord can be used together very easily to create expressive APIs that easily communicate with an underlying database in just a few lines of code. Although Sinatra applications by default do not provide an easy method of authentication for incoming requests, gems such as [sinatra-authentication](https://github.com/maxjustus/sinatra-authentication) exist to fill this void. Although Sinatra was used as a dumb RESTful request redirector in this example, [Sinatra can be used to create real web applications](http://www.sinatrarb.com/wild.html).