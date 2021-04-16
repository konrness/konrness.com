---
layout: post
title: "Hosting this site on Google Cloud Run"
description: "I have migrated this blog to a containerized static site running on Google Cloud Run"
date: 2021-04-16 13:18:18
comments: true
keywords: "gcp, google, static html, jekyll, docker"
tags: gcp, google, static html, jekyll, docker
category: devops
---

Since 2009, this blog, among other personal projects, was hosted on a VM on Rackspace. The $20 per month I was paying finally got to me, and I decided to migrate it to a new host. I selected Google Cloud Run. To do that, I needed to repackage the site into a Docker Container and migrate the domain.

This site is built using [Jekyll](https://jekyllrb.com/), which is a static site generator. I write the posts in markdown, and Jekyll transforms them into styled HTML. The site search is run with Javascript and a generated JSON site index.

Previously, I ran the Jekyll commands to build the site and manually uploaded them to the VM with SCP. I thought, if I'm going to migrate to a cloud native, containerized platform I should also replace the old-school techniques that I was using for build/release.

All of the code for this site, including the build/deploy process, is on [Github](https://github.com/konrness/konrness.com).

## Step 1 - Containerize the Build ##

The old way:

{% highlight bash %}
# deploy.sh
bundle exec jekyll build
scp -r _site/* venus@konrness.com:/vweb/konrness.com/docs/
{% endhighlight %}

The new way:

{% highlight bash %}
# build.sh
export JEKYLL_VERSION=2.5.3
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build
{% endhighlight %}

The benefits of containerizing the build process is that I no longer need to maintain a local Ruby installation and mess around with managing dependencies. Everything is built into the jekyll/jekyll Docker image and self-contained. When I'm done building, the container dies and nothing hangs around.

The result of this build is a new `_site` folder which is the static contents of the generated site, including directories, static assets (JS, CSS, fonts, etc.) and HTML files.

## Step 2 - Create a deployable artifact ##

Now that I have the site generated, the second step of the `build.sh` script packages the code into a Docker container.

{% highlight bash %}
# build.sh (continued)

docker build -t konrness/konrness.com .
{% endhighlight %}

Since the site is entirely static, I am using the `nginx:alpine` Docker image to deliver the site.

The Dockerfile is as simple as:
{% highlight bash %}
# Dockerfile
FROM nginx:alpine
COPY _site /usr/share/nginx/html
{% endhighlight %}

This copies the static site from `_site` into the default web directory for the `nginx` container.

I can then run this Docker container locally to preview and test the site.

{% highlight bash %}
# run.sh
docker run -p 8080:80 -it konrness/konrness.com
{% endhighlight %}

## Step 3 - Publish to Docker Hub ##

Once I have validated locally that the Docker image I have created is ready for release, I tag and push to Docker Hub and GCP Container Registry.

{% highlight bash %}
# release.sh
timestamp=$(date +%y.%-m.%-d)
 
echo Tagging version $timestamp
docker tag konrness/konrness.com konrness/konrness.com:$timestamp
 
echo Pushing tag: $timestamp
docker push konrness/konrness.com:$timestamp
 
echo Pushing tag: latest
docker push konrness/konrness.com:latest
 
echo Pruning...
docker system prune -f
{% endhighlight %}

The tag to be deployed is versioned based on the date. For instance, the tag I push on April 16th, 2021 would be named `konrness/konrness.com:21.4.16`. I push the tag to both Docker Hub as well as my personal Google Cloud Platform Container Registry because I am hosting the site on GCP Cloud Run, and Cloud Run does not support pulling Docker images from Docker Hub.

## Step 4 - Deploy to Cloud Run ##

The last step of the `release.sh` script is to deploy to Cloud Run.

{% highlight bash %}
# release.sh (continued)

echo Deploying to Cloud Run
gcloud run deploy konrness-com --image gcr.io/personal-sites-310123/konrness.com:$timestamp --region us-central1 --platform managed
{% endhighlight %}

Easy as that.

## What's Next ##

This build and release process is currently entirely scripted, and only run on my local workstation. In a future iteration of this, I plan to implement a CI/CD solution that will automate the process for me. I'll link to that here, when I get to it.