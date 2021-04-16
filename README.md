# konrness.com

Konr Ness' personal blog using Jekyll.

Visit the site at [http://konrness.com](http://konrness.com)

---

### To serve

1. Build Jekyll site and package in Docker container: `./build.sh`
2. Run nginx container: `./run.sh`

Access, [localhost:8080/](http://localhost:8080/)

### To build and deploy

    ./deploy.sh

---

### Using Rake tasks (to be rebuilt now that this is Dockerized)

* Create a new page: `bundle exec rake page name="contact.md"`
* Create a new post: `bundle exec rake post title="TITLE OF THE POST"`

---

### Copyright and license

It is under [the MIT license](/LICENSE).

Thanks [Mug](http://nandomoreira.me/mug/) for the theme.