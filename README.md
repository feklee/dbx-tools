Introduction
============

*dbx-tools* is a set of command line tools to *manually* keep a local
directory in sync with your Dropbox.

It depends on [dbxcli][1]


Sample session
==============

 1. Create a path for your Dropbox and tell dbx-tools about it.

        ~$ mkdir Dropbox
	~$ export DBX_HOME="$HOME/Dropbox"

 2. Enable `dbx-cd`:

        ~$ source "`which dbx-cd-source`"

 3. To get help on any command, use the `-h` option:

        ~$ dbx-ls -h
	...

 4. Navigate your Dropbox, noting that local paths are created if
    necessary:

	~$ dbx-ls
	~$ dbx-cd "My Data"
	~$ dbx-pwd
	My Data
	~$ pwd
	~/My Data

 5. Upload a file:

        echo "Hello World"

 6. Upload a directory:

 7. Download a file

 8. Download a directory

        dbx-ls -R dir
	find dir


License
=======

Except where noted otherwise, files are licensed under the WTFPL.

Copyright © 2018 [Felix E. Klee](felix.klee@inka.de)

This work is free. You can redistribute it and/or modify it under the terms of
the Do What The Fuck You Want To Public License, Version 2, as published by Sam
Hocevar. See the COPYING file for more details.

[1]: https://github.com/dropbox/dbxcli
