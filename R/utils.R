
#' store owncloud credentials
#'
#' The password is stored encrypted using 
#' \href{http://manpages.ubuntu.com/manpages/bionic/man1/secret-tool.1.html}{secret-tool}.
#'
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
#'
ocini <- function(url, user, pwd){
    stopifnot(Sys.info()['sysname'] == 'Linux')
    path = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.oc.cnf')
    
    if(missing(url)) {
        message("Enter your owncloud url:", appendLF = FALSE)
        url = readline()
        }
    
    if(missing(user)) {
        message("Enter your owncloud username:", appendLF = FALSE)
        user = readline()
        }

    if(missing(pwd)) 
        pwd = getPass::getPass("Enter your owncloud password\n(password will be stored encrypted):")
    
    # store password
    glue('printf "{pwd}" | secret-tool store --label="owncloud" {url} {user}') %>%
    system

    # store url & username
    dirname(path) %>%  
    dir.create(showWarnings = FALSE, recursive = TRUE)
    writeLines(c(url, user), path)
    
    }


getocini <- function() {
    path = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.oc.cnf')
    if(file.exists(path))
        stop('owncloud was not initialized. Run ocini() first.')
    x = readLines(path)

    pwd = glue('secret-tool lookup {x[1]} {x[2]}') %>%
          system(intern  = TRUE)
    o = c(x, pwd)
    names(o) = c('url', 'user', 'pwd')
    o

    }