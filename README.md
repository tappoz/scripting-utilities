Scripting utilities
===================

This project gathers all the scripts I found useful recalling from the command line for my daily tasks.
They might be `bash` / `awk` scripts, `python` scripts, or even `javascript` / `Node.js`.

I usually save these scripts in my home bin folder (`~/bin`) making sure that folder is in the `$PATH` so then I can recall these scripts from every folder 
in the file system.

#### Updating your `$PATH`
On your home folder (`/home/YOUR_USER_NAME` or simpy `~`)  amend the file `.bashrc` file with something like this:
```sh
PATH=${HOME}/bin:${PATH}
```
#### Making one of the scripts executable
In order to be sure the scripts are executable you need to run the following command:
```shell
$ chmod +x <script-name>
```
