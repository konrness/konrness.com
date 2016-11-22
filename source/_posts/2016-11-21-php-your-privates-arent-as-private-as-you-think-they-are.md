---
layout: post
title: "PHP: Your privates aren't as private as you think they are"
description: "Public, protected and protected are class-level visibility, not object-level. What does this mean for your object-oriented PHP?"
date: 2016-11-21 13:29:18
comments: true
keywords: "php, oop, public, protected, private, object visibility, class visibility, programming"
category: php
---

In PHP, we have three visibility keywords:

* `public`
* `protected`
* `private`

{% highlight php %}
 <?php
 
 class Student
 {
     private $classes;
 
     public function __construct($classes)
     {
         $this->classes = $classes;
     }
 
     public function getClasses()
     {
         return $this->classes;
     }
 }
 
 
 $mary = new Student(['CompSci2001', 'CompSci2002']);
 
{% endhighlight %}

In [this example](https://3v4l.org/3nLfb), we see `private` and `public` being used. The list of the students' classes are readable externally, 
but once the student is instantiated the list of classes cannot be modified. This is because the `classes` property is declared `private`.
 
A quote from the [PHP manual for Visibility](http://php.net/manual/en/language.oop5.visibility.php), describes the visibility keywords:

> Class members declared `public` can be accessed everywhere. Members declared `protected` can be accessed only within the 
> class itself and by inherited classes. Members declared as `private` may only be accessed by the class that defines the member.

But pay close attention to the wording there: "may only be accessed by the **class** that defines the member." 

A common misconception is that these visibilities are *object-level*. But they are not; they are *class-level*.
 
Consider [this example](https://3v4l.org/iGG8S) where **one instance** of a class modifies **the other instance's** private properties.

{% highlight php %}
<?php

class Student
{
    private $classes;

    public function __construct($classes)
    {
        $this->classes = $classes;
    }

    public function getClasses()
    {
        return $this->classes;
    }
    
    public function combineClasses(Student $otherStudent)
    {
        $allClasses = array_unique(
            array_merge(
                $this->classes, 
                $otherStudent->classes
            )
        );
        
        $this->classes         = $allClasses;
        $otherStudent->classes = $allClasses;
    }
}


$mary = new Student(['CompSci2001', 'CompSci2002']);
$john = new Student(['CompSci2002', 'CompSci2003']);

$mary->combineClasses($john);

{% endhighlight %}

### Dude, what?

After seeing the previous example, you may be thinking that surely PHP screwed up it's object-oriented implementation 
when it added visibility keywords in PHP 5? However, this same implementation of class-level visibility exists in
other popular languages:

* [Java](https://docs.oracle.com/javase/tutorial/java/javaOO/accesscontrol.html): Access level modifiers determine whether other classes can use a particular field or invoke a particular method. 
* [C#](https://msdn.microsoft.com/en-us/library/ms173121.aspx): The type or member can be accessed only by code in the same class or struct.
* [C++](https://msdn.microsoft.com/en-us/library/zfbte35d.aspx): The private keyword specifies that those members are accessible only from member functions ... of the class. 

The basics tenets of object-oriented programming allow for this.

### What does this mean to you as a PHP developer?

It's important to note that the reason we declare class members as `private` is to make the class more encapsulated.
Encapsulation allows for changing the internals of the class without affecting the code that uses your class. 
This still holds true with our new understanding about visibility, because the code that has access to your class's private members is *the class*.

We can all agree that the typical object-oriented model of having classes represent real-world objects, and setting 
visibility to limit the outside world from modifying properties is good. When following the "classes describe the real world"
technique, you can probably think of some realistic use-cases for exploiting class-level visibility. But like all 
powerful things, it is possible to do real harm when exploited.
