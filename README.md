Introduction
============

*dbx-tools* is a set of command line tools to manually keep a local
directory in sync with your Dropbox.

In a production environment, use one of the *releases* tagged in
Git. And, keep in mind: *This is experimental software!* Use it
responsibly, especially when manipulating lots of files at once.

dbx-tools depends on [dbxcli][1]. It was tested with dbxcli Git
release v2.1.1:

    dbxcli version: 0.1.0
    SDK version: 4.5.0
    Spec version: a1d5111

dbx-tools was originally written for interfacing with Dropbox from
within the [Termux][2] terminal emulator for Android.


Sample session
==============

 1. Make sure that `dbxcli` is available and that you are logged into
    Dropbox:

        ~$ dbxcli account

 2. Create a path for your Dropbox and tell dbx-tools about it.

        ~$ mkdir Dropbox
        ~$ export DBX_HOME="$HOME/Dropbox"

 3. Enable `dbx-cd`:

        ~$ source "`which dbx-cd-source`"

 4. To get help on any command, use the `-h` option:

        ~$ dbx-ls -h
        Usage: dbx-ls […]

 5. Navigate your Dropbox, noting that local paths are created if
    necessary:

        ~$ cd Dropbox
        ~/Dropbox$ dbx-ls
        Pictures/
        Documents/
        Info.txt
        ~/Dropbox$ dbx-cd Documents
        ~/Dropbox/Documents$ dbx-pwd
        /Documents

 6. Create and upload a file:

        ~/Dropbox$ echo Hello >Greeting.txt
        ~/Dropbox$ dbx-put Greeting.txt
        […]
        ~/Dropbox$ dbx-ls -l
        Revision         Size  Last modified  Path
        […]
        54913be5010b7a9a 6 B   47 seconds ago Greeting.txt
        […]
 
 7. Try to upload the same file again:
 
        ~/Dropbox$ dbx-put Greeting.txt
        [skipped]
  
    Files that have been previously uploaded are skipped. This
    functionality compares hashes of file meta data plus file
    content. If a file is moved, then its meta data changes, and it
    will be uploaded again on `dbx-put`.

 8. Create and upload a directory:

        ~/Dropbox$ mkdir Greetings
        ~/Dropbox$ echo Hello >Greetings/en
        ~/Dropbox$ echo Hallo >Greetings/de
        ~/Dropbox$ echo Salut >Greetings/fr
        ~/Dropbox$ echo Hola >Greetings/es
        ~/Dropbox$ dbx-put Greetings
        […]
        ~/Dropbox$ dbx-ls -R
        […]
        Greetings/
        […]
        Greetings/en
        Greetings/de
        Greetings/fr
        Greetings/es
        […]

 9. Download a file:
 
        ~/Dropbox$ dbx-get Goodbye.txt
        […]

10. Try to upload the same file again:
 
        ~/Dropbox$ dbx-get Goodbye.txt
        [skipped]
        
    Files that have been previously downloaded are skipped. This
    functionality compares revsions of files. Note that if a file is
    moved or renamed, then its revision changes, i.e. it will be
    downloaded again.

11. Download a directory

        ~/Dropbox$ dbx-get Goodbyes
        […]
 
12. Delete a file:

        ~/Dropbox$ dbx-rm Greetings.txt
        […]
        ~/Dropbox$ dbx-ls -l
        Revision         Size  Last modified  Path
        […]
        [remote file is missing]
        […]
        ~/Dropbox$ ls -l
        […]
        [local file has been deleted as well]
        […]

13. Remove a directory:

        ~/Dropbox$ dbx-rm -r Greetings
        […]

14. Clear hashes and revisions generated when uploading respectively
    downloading files:
    
        ~/Dropbox$ dbx-clear-cache
        […]
        
    Clearing the cache should rarely be necessary. It takes up little
    space, and keeping it prevents unnecessary uploads and downloads.


Coding conventions
==================

  * `$VARIABLE_NAME`
  
  * `function-name`
  
  * Maximum line length: 70
  
  * Indentation depth: 4 spaces


License
=======

Except where noted otherwise, files are licensed under the WTFPL.

Copyright © 2018 [Felix E. Klee](felix.klee@inka.de)

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

[1]: https://github.com/dropbox/dbxcli
[2]: https://termux.com
