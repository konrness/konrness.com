---
layout: post
title: "How to Create Javascript Objects"
description: "Javascript objects with public and private methods"
date: 2009-08-21 16:39:18
comments: true
keywords: "javascript, method, function, public, private"
category: javascript
---

It is easy to create Javascript objects, but this method goes one step further by allowing you to create a Javascript 
object with private and public methods, as well as private variables. It’s a perfect way to create a single access 
point for Javascript and Flash to communicate.  

The project I’m currently working on requires heavy interaction between a Flash object and the HTML/DOM. Links on the 
page need to call methods on the Flash object, and events in the Flash object need to trigger actions on the page.

I decided to create a DOM/Flash Connector in Javascript that would expose all of the methods that each can call into 
the other. I wanted it to be fully encapsulated, and as object oriented as possible.

One example of what it needed to do was show extended content (in HTML) that the Flash object was not large enough to 
display. For example, when a photo is displayed within the Flash object, the photo’s title, description, comments, tags, 
rating, etc. is displayed in HTML below the Flash object.

Here is the method I chose to use:

{% highlight javascript %}
var Connector = function(){

    var _flashElSelector = false;
    var _flashIsReady    = false;
    var _flash           = null;

    // load html into extended content area
    // this is a "private" method in the Connector class
    // it can only be called from within the returned object
    var _populateExtendedContent = function(url, data){
        $('#extendedcontent').load(url, data);
    };

    return {

        // initialize connector object
        // set the jQuery selector to be used for retrieving 
        // the Flash object element
        init : function(selector){
            _flashElSelector  = selector;
        },

        // flash is ready
        // flash calls this method as soon as it is ready to accept
        // incoming method calls
        flashReady : function(){
            // find flash object in DOM
            _flash        = $(_flashElSelector).get(0);
            _flashIsReady = true;
        },

        // show content for specified ID in extended content area
        showExtendedContent : function(id){
            // call the "private" method to display content in the
            // HTML part of the site
            _populateExtendedContent('/show/extendedcontent', {id : id} );
        },

        /**
         * Flash Methods
         */

        // show content for specified ID in Flash object
        showContent : function(id){

            // if flash isn't ready to accept method calls, ignore
            // this request
            if(_flashIsReady){

                // call the showContent() method on the Flash object
                // this is a method that is exposed by Flash that will
                // display content, based on the content's ID
                _flash.showContent(id);

                // call the showExtendedContent() method on the Connector
                // in this case, "this" refers to the same object as the
                // global "Connector" does
                // displays the extended content in the HTML area of the site
                this.showExtendedContent(id);

            }
        }

    }

// closure
}();

// set the jQuery selector for retrieving the Flash object
// this is done on the individual pages that have Flash to allow
// for different IDs for the Flash objects on each page
Connector.init('#flashobject');

{% endhighlight %}


If the user selected some content to be displayed within the Flash object, Flash would call to the connector as follows 
to display the extended information for the content in HTML.

{% highlight javascript %}
Connector.showExtendedContent(5);
{% endhighlight %}

If the user selected some content to be displayed within the HTML part of the site, Javascript would call to the 
connector as follows to display the content in Flash and the extended information for the content in HTML.

{% highlight javascript %}
Connector.showContent(5);
{% endhighlight %}

Note that since the function being assigned to `Connector` has the `();` at the end of it (line 67), it gets executed 
immediately. This function then returns an object that contains several functions and is assigned to the `Connector` 
variable. All of the variables and functions within `Connector`, that are not returned, are private and inaccessible 
from the global scope, but fully accessible from within the `Connector`, as evidenced by line 36.

If you have any questions regarding the script please feel free to post them here in the comments. I’m sure there are 
many other ways of creating Javascript objects, so please share your thoughts.