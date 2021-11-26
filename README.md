ProgressQuest on Lazarus
========================

This is a port of ProgressQuest to Lazarus. That is, free pascal.

It runs on Windows, Linux, and probably Mac (I have no Mac to test).

It uses new format for saves, with file extension .lpq, since old format
was very not friendly for porting. However, opening old saves is supported.

It looks like currently everything works, but more testing 
is probably needed. And yes - it _may_ kill your kittens.

Binaries for Windows and Linux are in the Downloads section.

Compilation instructions:

* install Lazarus http://www.lazarus.freepascal.org/

* download these sources

* open file pq.lpr with Lazarus

* hit Shift+f9 (or Menu->Run->Build) to produce an executable ('pq' for Linux, 'pq.exe' for Windows)