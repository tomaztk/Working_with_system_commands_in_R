################################################################
#
#      Working wiht System commands in R
#
#
# Author: Tomaz Kastrun
# Blog: tomaztsql.wordpress.com
# Description: Using windows cmd in R/Rstudio system / Sytem2
#              commands for interaction with cmd
# Date: 20200105
#
################################################################



################################################################
### 1 Simple dir command with order switch
################################################################

system("dir /o")
system2("dir /o")
shell("dir /o")
shell.exec("dir /o")

#both return the result to console pane
system("ping google.com")
shell("ping google.com -n 1")


################################################################
## 2 Chaining  cmd commands in R
################################################################

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


### defining a variable
shell("set mycounter=100 && echo %mycounter%")


################################################################
## 3 Typical CMD commands
################################################################

##3.1: Comparing two files using cmd fc / compare
setwd("C:\\Users\\Tomaz")

#create two files
write.csv(iris, file="iris_file1.csv")
write.csv(iris, file="iris_file2.csv")



#compare both files
shell("FC /a C:\\Users\\Tomaz\\iris_file1.csv C:\\Users\\Tomaz\\iris_file2.csv")

file1 <- "C:\\Users\\Tomaz\\iris_file1.csv"
file2 <- "C:\\Users\\Tomaz\\iris_file2.csv"

# or in R using all.equal
all.equal(readLines(file1), readLines(file2))


# run the same command using newer function "system2" and set the arguments

cmd_command <- "FC" 
#cmd_args <- "/a C:\\Users\\Tomaz\\iris_file1.csv C:\\Users\\Tomaz\\iris_file2.csv"
cmd_args <- c('/a', file1, file2)

rr <- system2(command=cmd_command,
            args= cmd_args, 
            stdout=TRUE,
            stderr=TRUE, 
            wait = TRUE)

#suppose we want to store the results in data.frame 

#empty dataframe
df_rr <- data.frame(file1 = character(),
                    file2 = character(),
                    fcompare = character(),
                    stringsAsFactors=FALSE)

#temporary results
temp <- data.frame(file1=file1, file2=file2, fcompare=rr[2])

#bind all into dataframe
df_rr <- rbind(df_rr, setNames(temp, names(df_rr)))

head(df_rr, 1)

# clean
rm(temp, rr, cmd_command, cmd_args)


################################################################
##3.2: rename
################################################################








##3.3: move / copy
##3.4: ping (pingpath)

pingcmd <- function(x,stderr=FALSE,stdout=FALSE,...){
  pingvector <- system2("ping",x," -n  1",
                        stderr=FALSE,
                        stdout=FALSE,
                        ...)
  if (pingvector == 0) TRUE else FALSE
}



##3.5: systeminfo
##3.6: tasklist (taskkill)
##3.7: ipconfig / netstat

