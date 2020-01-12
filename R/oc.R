

#' owncloud
#'
#' An owncloud client adapted for R. 
#'
#' @param dir       oc directory to synchronize, relative to basedir.
#'                  dir can be missing only if the root directory was synchronized already. 
#' @param basedir   local directory. default to ~/ownCloud/
#' @param exclude   files and/or file types to exclude. default to "*.sublime-workspace"
#'
#' @return owncloudcmd verbose output returned invisibly. 
#' 
#' @export
#' @importFrom rprojroot  has_file_pattern  find_root
#' 
owncloud <- function(dir, basedir = '~/ownCloud/', exclude = c("*.sublime-workspace")  ) {

    if(missing(dir)) {
        x = has_file_pattern('\\._sync_.*db$') %>% 
             find_root 
        dir     = basename(x)
        basedir = dirname(x)
    }

    cnf = getocini()

    glue('mkdir -p {basedir}/{dir}') %>% 
        system
    
    # make exclude file
    exf = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.owncloud_exclude.lst') 
    writeLines(exclude, exf)
    
    # run
    tf = tempfile()
    cmd = glue("owncloudcmd -h --nonshib --user {cnf['user']} --password {shQuote(cnf['pwd'])} --exclude {exf} \\
        {basedir}/{dir} https://{cnf['url']}/remote.php/nonshib-webdav/{dir} > {tf} 2>&1 ")
    
    system(cmd)
    
    invisible(readLines(tf))


}


