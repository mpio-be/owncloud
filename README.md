# owncloud
A thin wrapper around owncloudcmd. 

* run `ocini()` once to setup owncloud. 
* run `owncloud(dir, basedir)` to initiate sync. 
* run `owncloud()` without any arguments after a given working
    directory was synchronized at least once. 

You can run `owncloud()` any time but you'd probably want to have it at
the end of your script especially after any time consuming operation. 

