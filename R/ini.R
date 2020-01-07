

ocini <- function() {
    stopifnot(Sys.info()['sysname'] == 'Linux')
    cnf = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.oc.cnf')
    cnf
    if( !file.exists(cnf) ) 

    # secret-tool store  --label 'owncloudcmd' owncloudcmd  valcu@orn.mpg.de
    # secret-tool lookup owncloudcmd  valcu@orn.mpg.de

        

}

