
#' store owncloud url and username
#'
#' @param url  owncloud url
#' @param user user-name (often this is the user email)
#' @param pwd  user-password
#'
#' @return NULL
#' 
#' @author valcu@orn.mpg.de, \email{valcu@@orn.mpg.de}
#'
#' @export
#' @importFrom glue     glue
#' @importFrom magrittr "%>%"
#' @importFrom stringr  str_remove
#' @importFrom getPass  getPass
#'
ocini <- function(url, user, pwd){
    stopifnot(Sys.info()['sysname'] == 'Linux')
    path = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.oc.cnf')
    
    if(missing(url)) {
        message("\nEnter your owncloud url:", appendLF = FALSE)
        url = readline()
        url = str_remove(url, 'https://')

        }
    
    if(missing(user)) {
        message("Enter your owncloud username:", appendLF = FALSE)
        user = readline()
        }

   
    # store 
    dirname(path) %>%  
    dir.create(showWarnings = FALSE, recursive = TRUE)
    writeLines(c(url, user), path)
    

    }

getocini <- function() {
    path = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.oc.cnf')
    if(!file.exists(path))
        stop('owncloud was not initialized. Run ocini() first.')
    x = readLines(path)

    url  = x[1]
    user = x[2]
    
    if (! exists('.__ocpwd__') ) {
        message("Enter your owncloud password")
        message("[the password is only stored during the current session]")
        x = getPass()
        assign('.__ocpwd__', x, envir = .GlobalEnv)
        }


    o = c(url, user, .__ocpwd__)
    names(o) = c('url', 'user', 'pwd')
    o

    }

