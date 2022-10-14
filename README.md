# Jamf Pro Self Healing

## History
Since the days of Casper, Jamf Admins have been dealing with one annoying, yet consistent issue: Device Signature Error. If you get this error when either running "sudo jamf policy" or "sudo jamf recon" it means that the certificate trust between Jamf and the endpoint is broken. The only way to fix this is to re-enroll the computer, which often requires walking the users through the enrollment process. This got even more tricky with non-removeable MDM Profiles and when Jamf switched their web enrollment from a QuickAdd.pkg to an MDM profile. 

However, in 10.36, Jamf created an API call that allows a computer to be re-enrolled through an MDM Command. We have made this API call more excessible by allowing it to be easily run throught a script through Terminal. 

Thanks to Dr. Emily Kausalik-Whittle for bringing notice to this feature on her blog: https://www.modtitan.com/2022/02/jamf-binary-self-heal-with-jamf-api.html

## How it Works

This script will re-enroll the Mac through an API call by using an MDM command if we're getting that pesky "Device Signature Error." It must be run manually through through Terminal using Jamf Pro Credentials and manually entering the computer's ID.

## Instructions

In order to run this manually through Terminal, download the Individual Components and do the following:

1. Open Terminal
2. Run "sh /path/to/Jamf Self Healing - Manual Run.sh"
3. Enter the following when prompted:
    * Jamf Pro URL (EG: https://rocketman.jamfcloud.com/)
    * Jamf Pro Username (This should be a full administrator)
    * Jamf Pro Password
    * Computer ID (You can find this by navigating to the computer's inventory record and looking at **?id=3&o=r**. In this case, the ID would be "3") 
    
*Note: In most cases, you will be using a full admin account when running this script. However, the Jamf Pro user, at the very least, needs the following permissions:*
* Computers: Read
* Check-In: Read | Update
* Computer Check-In Settings: Read | Update
* Flush MDM Commands: Checked
* Send Computer Remote Command to Install Package: Checked
