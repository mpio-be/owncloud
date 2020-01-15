# owncloud
A thin wrapper around owncloudcmd. 

* run `ocini()` once to setup owncloud. 
* run `owncloud(dir, basedir)` to sync. 
You can run `owncloud()` any time but you'd probably want to have it at
the end of your script especially after any time consuming operation. 

Install with:

`remotes::install_github('mpio-be/owncloud')`
