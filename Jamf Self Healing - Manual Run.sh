#!/bin/zsh

: HEADER = <<'EOL'

██████╗  ██████╗  ██████╗██╗  ██╗███████╗████████╗███╗   ███╗ █████╗ ███╗   ██╗
██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝╚══██╔══╝████╗ ████║██╔══██╗████╗  ██║
██████╔╝██║   ██║██║     █████╔╝ █████╗     ██║   ██╔████╔██║███████║██╔██╗ ██║
██╔══██╗██║   ██║██║     ██╔═██╗ ██╔══╝     ██║   ██║╚██╔╝██║██╔══██║██║╚██╗██║
██║  ██║╚██████╔╝╚██████╗██║  ██╗███████╗   ██║   ██║ ╚═╝ ██║██║  ██║██║ ╚████║
╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝

       Name: Jamf Self Healing Script
Description: Uses the Jamf API to re-deploy the Jamf Enrollment package through an MDM Command.
             Meant to be run manually through Terminal on a Mac.
   Warnings: Jamf Pro 10.36 or higher is needed
             Computer must be MDM managed and receiving and processing MDM commands by the Jamf server.

 Created By: Chris Schasse
    Version: 2.0
    License: Copyright (c) 2022, Rocketman Management LLC. All rights reserved. Distributed under MIT License.
  More Info: For Documentation, Instructions and Latest Version, visit https://www.rocketman.tech/jamf-toolkit

EOL



##
## Defining Variables
##

printf "Enter Jamf URL: "
read URL

printf "Enter Jamf username: "
read USERNAME

printf "Enter password: "
read -s PASSWORD

echo "Please enter either the full path to a text file, where each line is a different Jamf Computer ID, or a single Jamf Computer ID."
printf "Full path to the Text File, or a Single Computer ID: "
read input

##
## Script Contents
##

APIHASH=$(printf "${USERNAME}:${PASSWORD}" | base64)

## Retrieve the authToken using the APIHASH
authToken=$(curl -X POST "${URL}/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic ${APIHASH}")
## Retrieve the api_token using the authToken
api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$authToken" | /usr/bin/xargs)

# Read the file line by line, including the last line without a newline character

if [[ -f "$input" ]]; then
  # Read the file line by line, including the last line without a newline character
  while IFS= read -r JAMFID; do
    # Echo the JAMFID
    echo "JAMFID: $JAMFID"
    JAMFID=$(echo $JAMFID | sed 's/\r//')
    curl -X POST "${URL}/api/v1/jamf-management-framework/redeploy/${JAMFID}" -H "accept: application/json" -H "Authorization: Bearer $api_token"
  done < "$input"
else
  # Check if the input is a JAMFID
  if [[ "$input" =~ ^-?[0-9]+$ ]]; then
    # Echo the JAMFID
    JAMFID=$input
    echo "JAMFID: $JAMFID"
    ## Run the API command to re-enroll the computer
    curl -X POST "${URL}/api/v1/jamf-management-framework/redeploy/${JAMFID}" -H "accept: application/json" -H "Authorization: Bearer $api_token"
  else
    echo "Invalid input. Please enter a valid CSV file path or a single JAMFID."
  fi
fi


