# Working_with_system_commands_in_R
R Examples for working with windows CMD commands from R code using 
the following commands:

1.fc / compare
2.rename
3.move / copy
4.ping (pingpath)
5.systeminfo
6.tasklist (taskkill)
7.ipconfig / netstat


Example of using file compare from R: 
```
cmd_command <- "FC" 
#cmd_args <- "/a C:\\Users\\Tomaz\\iris_file1.csv C:\\Users\\Tomaz\\iris_file2.csv"
cmd_args <- c('/a', file1, file2)

rr <- system2(command=cmd_command,
            args= cmd_args, 
            stdout=TRUE,
            stderr=TRUE, 
            wait = TRUE)

```


## Cloning the repository
You can follow the steps below to clone the repository. 
```
git clone -n https://github.com/tomaztk/Working_with_system_commands_in_R.git
```


## License
These samples and templates are all licensed under the MIT license.

## Questions
Email questions to: tomaztsql@gmail.com
