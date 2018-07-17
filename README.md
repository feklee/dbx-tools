Introduction
============

*dbx-tools* is a set of command line tools to *manually* keep a local
directory in sync with your Dropbox.

dbx-tools depends on [dbxcli][1]. It was tested with:

	dbxcli version: 0.1.0
	SDK version: 4.5.0
	Spec version: a1d5111

*This is experimental software!* Use it responsibly, i.e. better avoid
manipulations of large directories.


Sample session
==============

 1. Create a path for your Dropbox and tell dbx-tools about it.

        ~$ mkdir Dropbox
		~$ export DBX_HOME="$HOME/Dropbox"

 2. Enable `dbx-cd`:

        ~$ source "`which dbx-cd-source`"

 3. To get help on any command, use the `-h` option:

        ~$ dbx-ls -h
		Usage: dbx-ls […]

 4. Navigate your Dropbox, noting that local paths are created if
    necessary:

		~$ cd Dropbox
		~/Dropbox$ dbx-ls
		Pictures/
		Documents/
		README
		~/Dropbox$ dbx-cd Documents
		~/Dropbox/Documents$ dbx-pwd
		/Documents

 5. Create and upload a file:

		~/Dropbox$ echo Hello >Greeting.txt
		~/Dropbox$ dbx-put Greeting.txt
		[…]
		~/Dropbox$ dbx-ls -l
		Revision         Size  Last modified  Path
		[…]
		54913be5010b7a9a 6 B   47 seconds ago Greeting.txt
		[…]

 6. Create and upload a directory:

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

 7. Download a file:
 
	    ~/Dropbox$ dbx-get Goodbye.txt
		[…]

 8. Download a directory

        ~/Dropbox$ dbx-get Goodbyes
		[…]


License
=======

Except where noted otherwise, files are licensed under the WTFPL.

Copyright © 2018 [Felix E. Klee](felix.klee@inka.de)

This work is free. You can redistribute it and/or modify it under the terms of
the Do What The Fuck You Want To Public License, Version 2, as published by Sam
Hocevar. See the COPYING file for more details.

[1]: https://github.com/dropbox/dbxcli
