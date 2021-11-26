ProgressQuest on Lazarus
========================

This is a faithful port of ProgressQuest to Lazarus / Free Pascal.
It keeps the logic of the original game intact and has a few minor backend
improvements yeilding a slightly increased fps on killing fields and
brand new experience on a rare occasion when an in-game tick counter overflows.

It runs on Linux, and should run on Mac and Windows too.

It uses a new format for saves with file extension .lpq, since old format
was very unfriendly for porting. However, opening old saves is supported.

It looks like currently everything works, but more testing 
is always needed. And yes - it _may_ kill your kittens.

Compilation instructions:

* install Lazarus http://www.lazarus.freepascal.org/

* download these sources

* open file pq.lpr with Lazarus

* hit Shift+f9 (or Menu->Run->Build) to produce an executable ('pq' for Linux, 'pq.exe' for Windows)
