---
layout: post
title: "PHP Session Locks – How to Prevent Blocking Requests"
description: "How to use session_write_close() to prevent asynchronous requests from blocking the PHP session"
date: 2010-12-17 16:39:18
comments: true
keywords: "php, session, ajax, javascript, post, hanging"
category: php5
---

Many people are aware that modern browsers limit the number of concurrent connections to a specific domain to between 4 or 6. 
This means that if your web page loads dozens of asset files (js, images, css) from the same domain they will be queued 
up to not exceed this limit. This same problem can happen, but even worse, when your page needs to make several requests 
to PHP scripts that use sessions.

### Problem

PHP writes its session data to a file by default. When a request is made to a PHP script that starts the session 
(session_start()), this session file is locked. What this means is that if your web page makes numerous requests to PHP 
scripts, for instance, for loading content via Ajax, each request could be locking the session and preventing the other 
requests from completing.

The other requests will hang on session_start() until the session file is unlocked. This is especially bad if one of your 
Ajax requests is relatively long-running.

### Solution

The session file remains locked until the script completes _or_ the session is manually closed. To prevent multiple PHP 
requests (that need $_SESSION data) from blocking, you can start the session and then close the session. This will unlock 
the session file and allow the remaining requests to continue running, even before the initial request has completed.

To close the session, call:

{% highlight php %}
session_write_close();
{% endhighlight %}

This technique works great if you do not need to write to the session after your long-running process is complete. 
Fortunately, the $_SESSION data is still available to be read, but since the session is closed you may not write to it.

### Example

{% highlight php %}
<?php
// start the session
session_start();

// I can read/write to session
$_SESSION['latestRequestTime'] = time();

// close the session
session_write_close();

// now do my long-running code.

// still able to read from session, but not write
$twitterId = $_SESSION['twitterId'];

// dang Twitter can be slow, good thing my other Ajax calls
// aren't waiting for this to complete
$twitterFeed = fetchTwitterFeed($twitterId);

echo json_encode($twitterFeed);
{% endhighlight %}