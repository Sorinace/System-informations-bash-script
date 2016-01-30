System informations bash script.

The script has to take some informations from some system/config files, process them and write them to a text file. 
Text file should be rewritten every time the scrip is run.
Any standard linux command line tools can be used.
File format:
- multiple lines - separator is line feed ("\n")
- 2 columns per line - first column is Label, second column is the Value - column separator tab(\t)


Lines:

1. "Hostname"
2. "IP"
3. "ServerName" - from webserver config file
4. "ServerAlias" - from webserver config file - might be multiple lines
5. "Memory" (ram) - Total, Free, Used, Swap as label
6. "Disk Space Used" - on root /
7. "OS version"(not from some text file in config folder)
8. Listening ports - multiple lines like:
ServiceName<tab> Port - ServiceName as label, Port as Value.
9. Service status(running/stopped) using OS service tool management(any service, apache, mysql for example)
10. Service status(running/stopped) using alternative method - by service name
ServiceName <tab> Status - ServiceName as label, Status as Value.
11. Memory in use by a running aplication/service  - search by name. ServiceName as Label, memory in M as Value 

You might have to install some packages like apache and mysql.
Do as many lines as you can.




by MrsSarahPierce on 
