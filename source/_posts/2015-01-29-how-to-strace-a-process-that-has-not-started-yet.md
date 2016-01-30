---
layout: post
title: "How to strace a process that hasn't started yet"
description: "If you want to strace a process by name, but don't know the pid or it hasn't started yet, try this."
date: 2015-01-29 18:39:18
comments: true
keywords: "linux, strace, pid"
category: linux
---

My personal server, which runs this blog, was recently hacked. I knew that the server was sending out a constant stream 
of spam email, but I didn't know what process it was coming from. When I ran `top` I saw that a `perl` script was running
but I didn't know what it was doing, so I wanted to run `strace` on it.

With `strace` you can diagnose processes if you provide a process ID (PID), like:

    strace -vvtf -p 1234

However, the perl process was ending faster than I could capture the pid to strace it.

Using the following script, you can provide the process name and it will wait until the process starts, and then strace it:

    while true; do pid=$(pgrep 'processname' | head -1); if [[ -n "$pid" ]]; 
    then strace  -s 2000 -vvtf -p "$pid"; break; fi; done
    
This technique can be used to run strace on processes that have an unknown PID or for running strace on processes that are
ending before you can capture the PID.