# MIAV
FiveM Server Side Steam and Discord Enforcable Multi-tier Ping, White list and Ban script.

# Installing  
1. Breathe in.... Breathe out...  
2. put MIAV2 folder in resources  
3. import the miav2.sql file to your database. it is configured for "essentialmode" database by default.  
    meaning it will NOT disrupt your esx setup. change it if your database is not named "essentialmode".  
4. add the following to the top of your server.cfg  
    set mysql_connection_string "server=localhost;uid=mysqluser;password=password;database=essentialmode"  
    add_ace resource.MIAV2 command.sets allow  
5. add "start MIAV2" to your server.cfg  
6. enjoy.  

# Changing settings.
PREFERABLY, you should alter settings using and sql connection app such as phpmyadmin or hiediSQL  

# Removing Bans  
1. head into your database and delete the "banned" info in the miav_accounts table.
2. script does NOT need to be restarted. it updates on the fly.
- Thanks@!!  

Madkiwi & SinaCutie
