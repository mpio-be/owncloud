

#' @export
owncloud <- function(dir = "path_relative_to_ownCloud", exclude = c("*.sublime-workspace") , dryrun = FALSE, reset = FALSE) {

    cnf = config::get('owncloud')

    locDir = str_glue('~/ownCloud/{dir}')
    system(str_glue('mkdir -p {locDir}'))
    

    # make exclude file
    exf = '~/.owncloud_exclude.lst'
    writeLines(exclude, exf)
    

    # cmd
    if(reset) rm(.__owncloudcmd__, envir = .GlobalEnv)

    cmd = get0('.__owncloudcmd__', envir = .GlobalEnv)

    if(is.null(cmd) ) {
        cmd = str_glue(
            "owncloudcmd  --nonshib --user {cnf$user} --password {shQuote(cnf$pwd)} --exclude {exf} {locDir} https://{cnf$host}/remote.php/nonshib-webdav/{dir}")

        assign('.__owncloudcmd__', cmd, envir = .GlobalEnv)
        

        }

    cmd = get('.__owncloudcmd__', envir = .GlobalEnv)



    if(!dryrun)
        system(cmd)

    if(dryrun)
        cat(cmd)


}


