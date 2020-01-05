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


### Checking the usage
Sys.which("copy")
Sys.which("ping")


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

#################################################
# #3.1: Comparing two files with  fc / compare
#################################################

Sys.which("fc")
# "C:\\WINDOWS\\SYSTEM32\\fc.exe" 

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


#################################################
## 3.2: Rename
#################################################

Sys.which("rename")
#   "" 

setwd("C:\\Users\\Tomaz")

# renaming the file using shell command
# shell("ren c:\\users\\tomaz\\iris_file1.csv iris_file1_copy.csv")
shell("cd c:\\users\\tomaz && ren iris_file1.csv iris_file1_copy.csv")


file_old_name <- "c:\\users\\Tomaz\\iris_file2.csv"
file_new_name <- "iris_file2_new.csv"

cmd_command <- paste("RENAME", file_old_name, file_new_name) 

# System2 Does not work
# system2(command=cmd_command)
shell(cmd_command)

#clean
rm(file_old_name, file_new_name, cmd_command)



#################################################
## 3.3: Move / Copy
#################################################

Sys.which("copy")
#   "" 

setwd("C:\\Users\\Tomaz")

#Copying file
shell("copy c:\\Users\\Tomaz\\iris_file1.csv iris_file1_copy.csv")


# or with more parametrized

orig_file <- "c:\\Users\\Tomaz\\iris_file1.csv"
copy_file <- "iris_file1_copy1.csv"
command <- "copy" 

cmd_command <- paste(command, orig_file, copy_file)
shell(cmd_command)


#clean
rm(orig_file, copy_file, cmd_command, command)


#################################################
## 3.4: Ping command (pingpath)
#################################################

Sys.which("ping")
#   "C:\\WINDOWS\\SYSTEM32\\ping.exe"  

URL <- 'tomaztsql.wordpress.com'

cmd_command <- "Ping" 
cmd_args <- c('-n 1', URL)

system2(command=cmd_command,
              args= cmd_args, 
              stdout=TRUE,
              stderr=TRUE, 
              wait = TRUE)


rm(URL, cmd_command, cmd_args)

#suppose we want to store the results in data.frame 
#and let's do a function to check several pings

URLs <- c("google.com", "tomaztql.wordpress.com", "youtube.com")

#empty dataframe
df_rr <- data.frame(URL = character(),
                    reply = character(),
                    package = character(),
                    stringsAsFactors=FALSE)

ping_fn <- function(url) {
  system2("ping",c(url,' -n 1'),
                stdout=TRUE,
                stderr=TRUE)

}

for (i in 1:length(URLs)){
  site <- print(URLs[i])
  rr <- ping_fn(site)
  temp <- data.frame(URL=rr[2], reply=rr[3], package=rr[6])
  df_rr <- rbind(df_rr, setNames(temp, names(df_rr)))
}

head(df_rr)

rm(URLs, ping_fn, df_rr, temp, i, rr, site)

#################################################
## 3.5: systeminfo
#################################################

Sys.which("systeminfo")
#   "C:\\WINDOWS\\SYSTEM32\\systeminfo.exe" 


# R
R.Version()
Sys.info()
.Platform

# Using system2 

cmd_command <- "systeminfo" 
rr <- system2(command=cmd_command,
        stdout=TRUE,
        stderr=TRUE, 
        wait = TRUE)

#grabbing the e.g.: "System Manufacturer"
rr[13]


#################################################
## 3.6: tasklist (taskkill)
#################################################

Sys.which("tasklist")
#   "C:\\WINDOWS\\SYSTEM32\\tasklist.exe" 


cmd_command <- "tasklist" 
rr <- system2(command=cmd_command,
              stdout=TRUE,
              stderr=TRUE, 
              wait = TRUE)

# getting the results into something more readable format
dd <- tibble::enframe(rr)
stack(dd)[1]

# kill a specific task
shell("taskkill /F /PID 6816")

rm(cmd_command, rr, dd)

#################################################
## 3.7: ipconfig / netstat
#################################################

Sys.which("netstat")
# "C:\\WINDOWS\\SYSTEM32\\netstat.exe"


cmd_command <- "netstat" 
rr <- system2(command=cmd_command,
              stdout=TRUE,
              stderr=TRUE, 
              wait = TRUE)

dd <- tibble::enframe(rr)


rm(cmd_command, rr, dd)