# RDP security/authentication check
# Cobbled together by Thaddeus Cooper
#	@thaddeuslcooper
#	thad@thadcooper.com | thaddeuslcooper@gmail.com
#	https://github.com/suckerface
#
# Credit to citronneur for his great work on rdpy
#
# syntax `./rdpcheck.sh <iplist>
#
# Takes a list of IPs in provided file (line delimination) and does the following:
#	NLA Check - Attempts to connect to target with NLA disabled, takes screenshot of desktop session, and outputs to screenshot subdirectory in pwd
#	Authentication Check - Prompts for Domain, Username, and Password and attempts to authenticate to target with provided credentials. Outputs IP and results.
#
# Requirements:
# rdpy suite by Sylvain Peyrefitte (citronneur)
#	https://github.com/citronneur/rdpy
# FreeRDP Suite
#	https://github.com/FreeRDP/FreeRDP
# xvfb
#	should be included with X in most *nix systems

#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[1,37m'

if [ -z $1 ]; then
    echo "Usage: $0 <ip.list>"
    exit 1
fi


# Menu to provide options
#echo -e "${WHITE} Choose a test: "
PS3="Choose a test: "
test=("NLA Check" "Authentication Check" "Quit")
select testopt in "${test[@]}"

do
    case $testopt in
        "NLA Check")
            #create screenshots subdirectory
    		mkdir screenshots
   	    	echo "Output will be placed in the screenshots folder of the current directory."
			
           	# read input from file, run rdpy-rdpscreenshot within xvfb-run to connect to target, take headless screenshot, and dump to screenshot subdirectory
    		cat "$1" | while read IP; do xvfb-run -a --server-args="-screen 0, 1024x768x24" rdpy-rdpscreenshot.py -o `pwd`/screenshots/ $IP; done;
   	    	;;
        "Authentication Check") 
            echo "Enter domain: "
    		read domain

        	echo "Enter domain username: "
            read username

            echo "Enter domain password: "
            read -s password

   			# read input from file to auth-only check using xfreerdp to target
   			# domain can be hardcoded by editing the /d: switch, be sure to comment out/remove domain prompt above.
       		# xfreerdp dumps to stderr, this also redirects to stdout and pipes to grep to eliminate a ton of ugly and (mostly) unncessary output for easier readability.
            #cat "$1" | while read IP; do echo $IP && if xfreerdp /v:$IP:3389 /u:$username /d:$domain /p:$password +auth-only /cert-ignore 2>&1 | grep -q "exit status 0"; then echo "$IP success" else echo "$IP failure" fi; done; 
           	
            while read IP;
            do
                #echo $IP
                if xfreerdp /v:$IP /u:$username /d:$domain /p:$password +auth-only /cert-ignore 2>&1 | grep -q "exit status 0"; then
                    echo -e "${GREEN}$IP success${WHITE}"
                else
                    echo -e "${RED}$IP failure${WHITE}"
                fi
            done < "$1"

            ;;
		"Quit")
            break
       		;;
        *)
            echo "Invalid option, please select a number."
			;;
    esac
tput sgr0
#echo
done
