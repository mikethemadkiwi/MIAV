# MIAV
FiveM Server Side Steam-Enforced Multi-tier Ping, White list and Ban script.

# Installing  
1. Breathe in.... Breathe out...  
2. put MIAV2 folder in resources  
3. import the miav2.sql file to your database.   
NOTE!!! CHANGE THE DEFAULT DATABASE NAME AT THE TOP OF THE FILE  
4. add the following to the bottom of your server.cfg  
```
########################################################
# MIAV2
########################################################
add_ace resource.MIAV2 command allow
add_ace resource.MIAV2 command.quit deny
########################################################
# MIAV2 EVERYONE
########################################################
add_ace builtin.everyone miav2.info allow
add_ace builtin.everyone miav2.ticket.update allow
add_ace builtin.everyone miav2.ticket.create allow
########################################################
# MIAV2 REGULAR
########################################################
add_ace miav2.regular miav2.ticket.report allow
########################################################
# MIAV2 MODERATOR
########################################################
add_ace miav2.moderator miav2.wluser allow
add_ace miav2.moderator miav2.ban allow
add_ace miav2.moderator miav2.unban allow
add_ace miav2.moderator miav2.kick allow
add_ace miav2.moderator miav2.ticket.report allow
add_ace miav2.moderator miav2.ticket.transfer allow
add_ace miav2.moderator miav2.ticket.close allow
########################################################
# MIAV2 ADMIN
########################################################
add_ace miav2.admin miav2.wluser allow
add_ace miav2.admin miav2.ban allow
add_ace miav2.admin miav2.unban allow
add_ace miav2.admin miav2.kick allow
add_ace miav2.admin miav2.ticket.report allow
add_ace miav2.admin miav2.ticket.transfer allow
add_ace miav2.admin miav2.ticket.close allow
add_ace miav2.admin miav2.reload allow
add_ace miav2.admin miav2.wlserver allow
########################################################
# MIAV2 DEV
########################################################
add_ace miav2.dev miav2 allow
########################################################
# MIAV2 MISC
########################################################
add_ace miav2.misc miav2.misccommands allow
```
5. add "start MIAV2" to your server.cfg  
6. enjoy.  
  
# Changing settings.
PREFERABLY, you should alter settings using and sql connection app such as phpmyadmin or hiediSQL 
  
# Commands  
"/mv2"  
This command functions as the catchall command. subcommands are the real bread and butter.  
They are as following:  
```
-- mv2 info : Displays information about this mod.  
-- mv2 kick USERID: Kicks the user specified { /mv2 kick USERID REASON }  
    ( If reason is Blank, Defaultkick from SQL settings table will be used )  
-- mv2 ban USERID: Bans the specified user { /mv2 kick USERID REASON }  
    ( If reason is Blank, Defaultkick from SQL settings table will be used )  
-- mv2 unban : Loads the ban interface, allowing a user to be searched and unbanned.  
-- mv2 report : Creates a report that admins and mods can respond to.  
-- mv2 ticket : Create and update msgs to and from admin in the ingame ticketing system.  
-- mv2 wluser 0-500: Alters the user's whitelist access level in the database by the specified amount.  
    ( they user will require a restar of thier client for hardcoded permission to reapply. )  
-- mv2 wlserver 0-500: Alters the global whitelist level in the database by the specified amount. 
-- mv2 reload : Reloads the config from the Database and sets it as default.  
    ( useful for updating settings manually )  
-- mv2 users : SERVER ONLY. displays a list of connected users and thier identifiers  
```
- Thanks@!!  

Madkiwi & SinaCutie
