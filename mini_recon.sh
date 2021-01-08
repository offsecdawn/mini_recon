#!/bin/bash

#Function1
getURL(){
rm -rf url.txt files_tmp.txt JScanner_links.txt custom_regex.txt url.txt nuclei-result
read -p "Enter the URL to be processed:" value
#read -p "Enter the cookie value if available:" cookie
#read -p "Enter the domain value:" domain
domain=`echo "$value" | python3 -c "import re,sys; str0=str(sys.stdin.readlines()); str1=re.search('(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]', str0);  print(str1.group(0)) if str1 is not None else exit()" | sed 's/www\.//g'`
if [ -z "$value" ];then
	echo "Input value is empty.Please enter the URL."
	exit
else
	echo $value > url.txt
fi
if [ -z "$domain" ];then
        echo "Domain value is empty.Please enter the domain value."
        exit
fi
}

#Function2
#Function to enumerate all files existing under the URL(s)
enum_FILES(){
cat url.txt > files_tmp.txt
cat url.txt | subjs >> files_tmp.txt
if [ -z "$cookie" ];then
	#echo "check1"
	echo $value | ~/go/bin/hakrawler  -depth 3 -scope subs -plain | anew files_tmp.txt
else
   	#echo "check2"
	echo $value | ~/go/bin/hakrawler  -depth 3 -scope subs -plain -cookie $cookie | anew files_tmp.txt
fi
cat files_tmp.txt | grep -i $domain > files.txt
echo "!!All enumerated files are stored in files.txt file successfully!!"
#cat files.txt
}
#Function3
#Funtion to identify GF patterns
gf_PATTERN(){
for i in $(cat gf_patterns)
do
       for j in $(cat files.txt)
       do
               echo "----------------------------------------------------------------------------------------------"
               echo "URL:$j"
               echo "Pattern:$i"
               curl -k --compressed $j --silent | tac |tac |gf $i
               echo "----------------------------------------------------------------------------------------------"
       done
done
}

#Function5
#For extracting links from URLs and Javascript files
link_extractor(){
if [ -z "$cookie" ];then
	for i in $(cat files.txt)
	do
		#echo "-------------------------Custom regex match $i-------------------------------" | anew JScanner_results.txt
		echo "URL Value:"$i
		python3 /opt/tools/auto_recon/JSFinder/JSFinder.py -u $i -ou /opt/tools/auto_recon/links.txt -os /opt/tools/auto_recon/sub_domains.txt
 		echo "$i" | python3 /opt/tools/javascript_enumeration/jsa/jsa.py | anew /opt/tools/auto_recon/links.txt
		#python3 /opt/tools/javascript_enumeration/JScanner-3.0/JScanner.py -u $i -d $domain -t 40  | anew  JScanner_results.txt
		#hakrawler -url $i -linkfinder -scope strict -plain| cut -d " " -f1 | cut -d "\"" -f2 | anew JScanner_links.txt
	done
else
	for i in $(cat files.txt)
        do
		echo "-------------------------Custom regex match $i-------------------------------" | anew JScanner_results.txt
		echo $i
                #python3 /opt/tools/auto_recon/JSFinder/JSFinder.py -u $i  -c "$cookie" -ou /opt/tools/auto_recon/links.txt -os /opt/tools/auto_recon/sub_domains.txt
		#python3 /opt/tools/javascript_enumeration/JScanner-3.0/JScanner.py -u $i -d $domain -t 40  | anew JScanner_results.txt
		#hakrawler -url $i -linkfinder -scope strict -plain| cut -d " " -f1 | cut -d "\"" -f2 | anew JScanner_links.txt
        done
fi
	#grep -i "Found endpoint" JScanner_results.txt | cut -d " " -f4 | anew JScanner_links.txt
	#grep -i "Custom regex match" JScanner_results.txt | anew custom_regex.txt
	#cat links.txt | anew links.txt
	#cat sub_domains.txt | anew sub_domains.txt
}

##Funtion5
#Nuclei function has been created to check for credentials and sensitive informations.
nuclei-check()
{

cat url.txt links.txt | nuclei -t /root/nuclei-templates/enumeration/ -silent | anew nuclei-result
cat url.txt links.txt | nuclei -t /opt/tools/javascript_enumeration/jsa/templates/ -silent | anew nuclei-result

}


#Script starts here
echo "-------------------------------------------------------------"
getURL
enum_FILES
gf_PATTERN
link_extractor
nuclei-check
rm -rf files_tmp.txt files.txt links.txt sub_domains.txt JScanner_results.txt
