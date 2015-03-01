#!/bin/sh       
                                                                                                                                      
# Dev Domain Create                                                         
                                                                            
# Read conf vars                                                            
source ./dev.conf       

# Read Args
domain="$1"                      

#printf "$vhostPath"

# Functions
# Create
function create(){
	domain="$1"
	if [ -n "$domain" ] && [ -n "$vhostPath" ] && [ -n "$templatePath" ] && [ -n "$vhostConfgPath" ]; then

		destPath="$vhostPath/$domain"

		# Run only if the Domain doesn't exist
		if [ ! -d "$destPath" ]; then

			# Copy template files
			cp -rp "$templatePath" "$destPath" 
			
			# Replace domain in index.php
			sed -i "s/template/$domain/g" "$destPath/httpdocs/index.php" 		
		
			# Search & replace httpd.include
			sed -i "s/template/$domain/g" "$destPath/conf/httpd.include" 
			
			# Search & replace vhost.conf
			sed -i "s/template/$domain/g" "$destPath/conf/vhost.conf" 

			# Remove Desc Script folder
			rm -rf "$destPath/script"

			# Add include to httpd.conf
			if grep -qs "$destPath/conf/httpd.include" "$vhostConfgPath"
			then
				printf "Entry already exist\n"
			else
				echo "Include $destPath/conf/httpd.include" >> "$vhostConfgPath"
			fi

			# Restart Apache
			service httpd reload
		
			printf "Domain created: $domain.dev.alfredkan.com \n"
		else
			printf "$domain.dev.alfredkan.com : already exist \n"
		fi
	fi
}


# If domain not empty
if [ -n "$domain" ]; then
	#printf "$domain\n"
	create $domain # Call create function
else
	printf "Please Enter A Domain... \n"
fi


