#!/bin/bash

#set -x

# Created by Emre Uydu - Infrastructure System Engineer
# emreuydu@gmail.com
# You can use this script to determine geo location of target device(s)
# The script will apply force logout if unapproved location detected. 
# Contact to me for more info
# Thank you for Greg Vincent for his support on this script 

#Instruction
# Add Your JAMF Server URL to the line 33
# Add ID number of your extension attribute to the line 34
# Add name of your extension attribute to the line 35
# Add items, name, ID of your extension atrribute between line 83 and 94 (add new lines if necessary) 

# Help blurb
_Help()
{
   # Display Help
   echo
   echo "Batch Update for Device Status Extension Atribute."
   echo
   echo "Syntax: ${0} userName [inputFileName.csv] "
   echo
   echo "Input file should have col 1 with Serial and col 2 with Device Status"
   echo
}

# Set vars for server and EA

jamfpro_url=""
eaID="" 
eaName=""

# Grab username from comand line or exit
[[ -z "${1}" ]] && echo "No Username provided, exiting." && _Help && exit 100
userName="${1}"

# Grab input file from command line or use default file and test that it exists
[[ -z "${2}" ]] && inputFileName="EAassignment.csv" || inputFileName="${2}"
[ ! -f "${inputFileName}" ] && echo "Input file ("${inputFileName}") does not exist, exiting." && _Help && exit 101

## Grab password from command line
echo -n Password: 
read -s userPassword
echo

echo "Username: $userName"
#echo "UserPassword: $userPassword"
echo

api_token=$(/usr/bin/curl -X POST --silent -u "${userName}:${userPassword}" "${jamfpro_url}/api/v1/auth/token" | plutil -extract token raw -)
echo "API Token: [$api_token]"
echo "---"

while IFS= read -r LINE || [[ -n "$LINE" ]]; do
      serialNumber=$(echo $LINE | cut -d "," -f 1)
      eaValue=$(echo $LINE | cut -d "," -f 2 )
      eaValue=${eaValue/&/&amp;}
      #echo "line: $LINE"
      #echo 
      #echo "serialNumber: [$serialNumber]"
      #echo "eaValue: [$eaValue]"
      xmlData="<computer><extension_attributes><extension_attribute><id>${eaID}</id><name>${eaName}</name><type>String</type><value>${eaValue}</value></extension_attribute></extension_attributes></computer>"
      #echo "XML: ${xmlData}"
      curl -s -X PUT https://$jamfserver/JSSResource/computers/serialnumber/${serialNumber}/subset/extension_attributes \
                  -H 'Content-Type: application/xml' \
                  -H 'Accept: application/xml' \
                  -H "Authorization: Bearer ${api_token}" \
                  -d "${xmlData}"
      echo "line: ${LINE}"
      #echo "Return code: $?"

done < ${inputFileName}


exit 0


:'
EA Name: YOUR EA NAME
EA ID: YOUR EA ID

ITEM1
ITEM2		
ITEM3	
ITEM4	
ITEM5	
ITEM6	
ITEM7	

'



