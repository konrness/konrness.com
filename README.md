# konrness.com

Konr Ness' personal blog using Jekyll

---

### To serve

1. Install Ruby gems: `bundle install --path vendor/bundle`
2. Start Jekyll server: `bundle exec jekyll serve`

Access, [localhost:4000/mug](http://localhost:4000/mug)

### To build and deploy

    ./deploy.sh

---

### Using Rake tasks

* Create a new page: `bundle exec rake page name="contact.md"`
* Create a new post: `bundle exec rake post title="TITLE OF THE POST"`

---

### Copyright and license

It is under [the MIT license](/LICENSE).

Thanks [Mug](http://nandomoreira.me/mug/) for the theme.