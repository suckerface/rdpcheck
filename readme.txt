RDP security/authentication check
    Cobbled together by Thaddeus Cooper
    @thaddeuslcooper
    thad@thadcooper.com | thaddeuslcooper@gmail.com
    https://github.com/suckerface

Credit to citronneur for his great work on rdpy

syntax `./rdpcheck.sh <iplist>

Takes a list of IPs in provided file (line delimination) and does the following:
    NLA Check - Attempts to connect to target with NLA disabled, takes screenshot of desktop session, and outputs to screenshot subdirectory in pwd
    Authentication Check - Prompts for Domain, Username, and Password and attempts to authenticate to target with provided credentials. Outputs IP and results.

Requirements:

rdpy suite by Sylvain Peyrefitte (citronneur)
    https://github.com/citronneur/rdpy
FreeRDP Suite
    https://github.com/FreeRDP/FreeRDP
xvfb
    should be included with X in most *nix systems
