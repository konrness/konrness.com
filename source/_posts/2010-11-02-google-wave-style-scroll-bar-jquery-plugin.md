---
layout: post
title: "Google Wave-style scroll bar jQuery plugin"
description: "jQuery plugin for a Google Wave-style scroll bar"
date: 2010-11-02 16:39:18
comments: true
keywords: "jquery, google wave, scroll bar"
category: javascript
---

Google Wave introduced a revolutionary new way of online communication and collaboration. It seemed to swiftly solve 
the problems inherent our current 40-year-old email system. Unfortunately, it never actually caught on.

![Google Wave Scrollbar screenshot](/images/scrollbar.png "Google Wave Scrollbar")

In addition to rethinking email, though, Google Wave’s user interface also rethought things such as scroll bars. 
I was particularly impressed with Google Wave’s scrollbars which were small, unintrusive, and easy to use.

In it’s tiny form-factor, the Google Wave scroll bar is able to:

*   Indicate document height
*   Indicate current scroll location
*   Scroll by clicking the arrows (dragger doesn’t move until you move your mouse away)
*   Scroll by dragging

After being announced that [Google Wave will be retired](http://googleblog.blogspot.com/2010/08/update-on-google-wave.html), 
I wanted to immortalize this new way of scrolling in a jQuery plugin that does the same thing.

[**View Demo**](http://code.konrness.com/google-wave-scrollbar/)

It currently does not work in IE because it uses CSS image data instead of referencing an actual image URL, but upon 
changing the image CSS, it will work in IE.

This is an alpha release, so please recommend changes or express your interest in a more configurable plugin.