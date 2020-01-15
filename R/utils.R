
#' store owncloud credentials
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
#' @importFrom sodium   keygen
#' @importFrom cyphr    key_sodium  encrypt_string decrypt_string
#' @importFrom stringr  str_remove
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

    if(missing(pwd)) {
        pwd = getPass::getPass("Enter your owncloud password\n(password will be stored encrypted):")
    }

    saveRDS(keygen() %>% key_sodium, paste0(path, '.k'))

     pwd = encrypt_string(pwd, readRDS(paste0(path, '.k'))) %>% as.character
     
   
    # store 
    dirname(path) %>%  
    dir.create(showWarnings = FALSE, recursive = TRUE)
    writeLines(c(url, user, pwd), path)
    

    }

getocini <- function() {
    path = paste0(system('echo $HOME', intern=TRUE), '/.config/owncloudcmd/.oc.cnf')
    if(!file.exists(path))
        stop('owncloud was not initialized. Run ocini() first.')
    x = readLines(path)

    url  = x[1]
    user = x[2]
    pwd  = x[3:length(x)] %>% 
          as.hexmode %>% 
          as.raw %>% 
          decrypt_string(key = readRDS(paste0(path, '.k')) )

    o = c(url, user, pwd)
    names(o) = c('url', 'user', 'pwd')
    o

    }

