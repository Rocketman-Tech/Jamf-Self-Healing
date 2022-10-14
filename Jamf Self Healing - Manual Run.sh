#!/bin/bash

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
    Version: 1.0
    License: Copyright (c) 2022, Rocketman Management LLC. All rights reserved. Distributed under MIT License.
  More Info: For Documentation, Instructions and Latest Version, visit https://www.rocketman.tech/jamf-toolkit             

EOL

##
## Defining Variables
##

echo -n "Enter Jamf URL: "
read URL

echo -n "Enter Jamf username: "
read USERNAME

echo -n "Enter password: "
read -s PASSWORD

echo -n "Enter the Computer ID: "
read JAMFID

##
## Script Contents
##

APIHASH=$(echo -n "${USERNAME}:${PASSWORD}" | base64)

## Retrieve the authToken using the APIHASH
authToken=$(curl -X POST "${URL}api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic ${APIHASH}")
## Retrieve the api_token using the authToken
api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$authToken" | /usr/bin/xargs)

## Run the API command to re-enroll the computer
curl -X POST "${URL}api/v1/jamf-management-framework/redeploy/${JAMFID}" -H "accept: application/json" -H "Authorization: Bearer $api_token"
