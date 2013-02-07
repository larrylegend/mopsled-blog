---
layout: post
title: Extending Jekyll
---
### About Jekyll
[Jekyll](http://jekyllrb.com/) is a static website generator that is structured to make blog generation easy.

Jekyll is a static website generator, meaning that it operates very differently from dynamic content management systems like WordPress. Posts are written in a markup language, such as Markdown or Textile or HTML, and simply saved as individual files in a designated directory. When activated, the `jekyll` gem will convert these individual files into basic HTML and output the entire website into a folder. Because the generated website is just in HTML, the files can be hosted virtually anywhere and don't suffer any security problems than dynamic languages can create. 

One of many static website generators, jekyll embraces simplicity and ease of use, sacrificing some functionality that dynamic blog software can provide. Although jekyll itself cannot provide dynamic features like users and commenting, it can make use of external services such as [DISQUS](http://disqus.com/) to provide thrid-party hosted comments.

### Jekyll Extensions
Jekyll uses [Liquid](http://www.liquidmarkup.org/) to generate web pages based off of simple templates. Liquid provides [some useful tags](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers) to generate and manipulate content within a post, and jekyll adds [some functionality](https://github.com/mojombo/jekyll/wiki/Liquid-Extensions) to Liquid as well. 

Although jekyll and liquid templates are very powerful, there aren't very many functions built-in to the system for complex operations. When coming to jekyll from a more featured blogging system such as WordPress, jekyll may seem restrictive. Fortunately, this is not the case:  adding new and powerful functionality to the templating system is very easy using [jekyll_ext](https://github.com/rfelix/jekyll_ext/).

### Project Setup for jekyll_ext
Given a basic [jekyll folder configuration](https://github.com/mojombo/jekyll/wiki/Usage), extending jekyll with `jekyll_ext` is simple:

1. Install the `jekyll_ext` gem:
    {% highlight bash %}gem install jekyll_ext{% endhighlight %}
2. Create an `_extensions` folder in your project structure
3. Write jekyll extensions as `.rb` files anywhere in the `_extensions` directory
4. Use the `ejekyll` command instead of `jekyll` when generating your static website. `ejekyll` wraps the normal `jekyll` call, but loads all `.rb` files in `_extensions/` into memory first.

### Custom Liquid Tags
Here's a bare-bones Liquid tag extension:

{% render_gist https://gist.github.com/raw/4378238/a151c4a451ec79d59f243691ce8e3eef6d43e709/tag-bare.rb %}

In your template:
{% highlight html %}
{% raw %}
<p>Output of custom tag: {% my_custom_tag var1 var2 %}</p>
{% endraw %}
{% endhighlight %}

This would produce:
{% highlight html %}
<p>Output of custom tag: Received params: 'var1 var2'!</p>
{% endhighlight %}

### Liquid Tag Example

{% render_gist https://gist.github.com/raw/4386193/3127f1bd3e4068d5ba0ce2907334a3308dec20bb/tag-example.rb %}

This tag is invoked like this:
{% highlight html %}
{% raw %}
{% yaml_to_array links.yml links_array %}
{% endraw %}
{% endhighlight %}

This will read links specified in [YAML](http://en.wikipedia.org/wiki/YAML) format in the file `_includes/links.yml` into the variable `links_array`. Here's an example `links.yml` file:
{% highlight yaml %}
- title: NSHipster
  url:   http://nshipster.com/
- title: NSBlog
  url:   http://www.mikeash.com/pyblog/
{% endhighlight %}

After the tag is invoked, the `links_array` variable can been used in a `for` loop to generate a list of links:
{% highlight html %}
{% raw %}
<section class="links">
    <ul>
        {% yaml_to_array links.yaml, links_array %}
        {% for link in links_array %}
            <li><a href="{{ link.url }}">{{ link.title }}</a></li>
        {% endfor %}
    </ul>
</section>
{% endraw %}
{% endhighlight %}

### Custom Liquid Filters
Here's a basic Liquid filter implementation:

{% render_gist https://gist.github.com/raw/4386225/b18a9571b62e5c0fd727a0e30b8e17aadaef3de4/filter-bare.rb %}

In your template:
{% highlight html %}
{% raw %}
<p>{{ "loud noises" | my_filter }}</p>
{% endraw %}
{% endhighlight %}

This would produce:
{% highlight html %}
<p>Filtered input: 'LOUD NOISES'</p>
{% endhighlight %}

### Liquid Filter Example

I use a custom filter on this website to generate relative dates, such as "3 weeks ago" rather than an exact date such as "25 December 2012":

{% render_gist https://gist.github.com/raw/4386236/79b3f360b17a00e79ec79e655a8fd5d19041b525/filter-example.rb %}

For example, the date of this post could be expressed using a jekyll filter: 
{% raw %}
    {{ page.date | date_to_long_string }}
{% endraw %}

produces

    {{ page.date | date_to_long_string }}

Using my custom filter:
{% raw %}
    {{ page.date | relative_date }}
{% endraw %}

produces

    {{ page.date | relative_date }}

### Wrap Up
As the examples above demonstrate, writing new Liquid filters and extending functionality is very easy and only requires some basic Ruby experience. To learn more about the flexibility of the `jekyll_ext` gem, check out the author's blog post _[Jekyll Extensions -= Pain](http://rfelix.com/2010/01/19/jekyll-extensions-minus-equal-pain/)_. There is a lot more functionality possible through the `jekyll_ext` gem than in the examples provided above.
