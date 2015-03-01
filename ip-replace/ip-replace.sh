#!/bin/sh

#ip Replace Script

# Read conf vars
source ./ip-replace.conf

# Run if all vars are available
if [ -n "$oldIp" ] && [ -n "$newIp" ] && [ -n "$filePaths" ]; then

	for filePath in ${filePaths[*]}
	do
		#for file in `find $filePath -exec grep -I "$oldIp" {} \;`
		for file in `find $filePath -type f`
		do
			# Stream inline edit - search & replace ips
			sed -i "s/$oldIp/$newIp/g" "$file"
			printf "%s\n" $file
		done
	done


	printf "Ip Has Been Replaced\n"
fi





# Test Search
#for i in `find . -name “$1″ -exec grep -l “$2″ {} \;`

