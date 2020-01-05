#####################################
#
# Working wiht System commands in R
#
#
# Author: Tomaz Kastrun
# Blog: tomaztsql.wordpress.com
# Description: Using windows cmd in R/Rstudio system / Sytem2
#              commands for interaction with cmd
# Date: 20200105
#
#####################################


 ## 1 Simple dir command with order switch

system("dir /o")
system2("dir /o")
shell("dir /o")
shell.exec("dir /o")

#both return the result to console pane
system("ping google.com")
shell("ping google.com -n 1")



## 2 Chaining  cmd commands in R
setwd("C:\\Users\\Tomaz")

### not work
shell("dir")
shell("cd ..")
shell("dir")

### will work
shell("dir && cd .. &&  dir")
shell("dir & cd .. &  dir")


### adding echo
shell ("echo hello && dir && echo by by")
shell ("echo You ran the command at:  %TIME%  on: %DATE% && dir")


### checking the environment variables
getwd()
Sys.getenv(c("R_HOME","HOME"))


## 3 Typical CMD commands