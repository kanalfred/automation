#!/usr/bin/perl

# Cron
# 01 00 * * * perl /usr/local/bin/backupDB.pl
############ Config Vars #############################

$mysqluser="admin";  # Mysql user with root access

#$mysqlpassword="w104\@r4t0\!";  # Mysql user password
$mysqlpassword="xxxxx";  # Mysql user password

@exclude=('test','information_schema','mysql','mysql.event'); # exclude these databases ('db_name', 'db2_name', ...)

$backupdir="/var/backup/mysql";   # Directory where backup files will be saved exclude trailing slash (/)

$mysqlshow ="/usr/bin/mysqlshow"; # Location of the mysqlshow command

$mysqldump ="/usr/bin/mysqldump"; # Location of the mysqldump command

########## Do not edit below this line ###########################


@databases= `$mysqlshow -u $mysqluser --password=$mysqlpassword`;

$i=0;

foreach $db (@databases){
	if($i>2 && $db!~/^\+/){	
	$db=~s/\s//g;
        $db=~s/\|//g;	
		foreach (@exclude){
			if($db eq $_){
 				splice(@databases, $i, 1);
			}	
		}
        }
	$i++;	
}
$i=0;
foreach $db (@databases){
        if($i>2 && $db!~/^\+/){
                $db=~s/\s//g;
                $db=~s/\|//g;
               # print "$mysqldump -u $mysqluser --password=$mysqlpassword $db > $backupdir/$db.sql \n";
                `$mysqldump -u $mysqluser --password=$mysqlpassword --events $db > $backupdir/$db.sql`;
               
        }
        $i++;
}
