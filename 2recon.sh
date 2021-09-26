#!/bin/bash

domain=$1
domain_meg(){
mkdir -p $domain/recon/meg $domain/recon/screenshots
meg / $domain/recon/httpx.txt $domain/recon/meg/output -L -H "Referer:Roshan.com" -H "User-Agent:Roshan.browser"
cd $domain/recon/meg/output/
grep -Hnri "Roshan" |tee xss_header_result.txt
}
domain_meg

domain_eyewitness(){

cd /home/deathpool/tools/EyeWitness/Python/
#Please change this directory when 2recon.sh is moved to another folder
./EyeWitness.py -f /home/deathpool/$domain/domains.txt -d /home/deathpool/$domain/recon/screenshots --timeout 15 --delay 5 
cd /home/deathpool
}
domain_eyewitness

domain_pythonserver(){
cd $domain/recon/screenshots/
python -m SimpleHTTPServer

}
domain_pythonserver
