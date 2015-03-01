#!/bin/sh
                                                                                                                                      
# Dev Domain Create                                                         
                                                                            
# Read conf vars                                                            
source ./dev.conf       

# Read Args
domain="$1"                      

printf "$vhostPath"

# Functions
# Delete
function delete(){
	domain="$1"
	if [ -n "$domain" ] && [ -n "$vhostPath" ] && [ -n "$templatePath" ] && [ -n "$vhostConfgPath" ]; then
		
		destPath="$vhostPath/$domain"
		
		# Delete only if the Domain Dir exist
		if [ -d "$destPath" ]; then

			# Remove domain folders & files
			rm -rf "$destPath"

			# Remove include in httpd.conf
			if grep -qs "Include $destPath/conf/httpd.include" "$vhostConfgPath"
			then
				# Remove include in httpd.conf
				removeStr="$domain\/conf\/httpd.include"

				#printf $removeStr
				sed -i "/$domain/d" "$vhostConfgPath"

				#echo "removed line"
			else
				echo "Domain Include doesn't exist in : $vhostConfgPath"
			fi

			# Restart Apache
			#service httpd reload
			
			printf "Domain Deleted: $domain.dev.alfredkan.com \n"
		else
			printf "Domain doesn't Exist \n"
		fi	
		
	fi
}

# Delete

# If domain not empty
if [ -n "$domain" ]; then
	#printf "$domain\n"

	read -p "$domain Confirm (y/n)? " -n 1 -r

	# Comfrim Message
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		printf "Delete $domain startint...... \n"

		# Call create function
		delete $domain 
	else
		printf "\n Delete Has Canceled \n"
	fi
else
	printf "Please Enter A Domain... \n"
fi


                                                                         
