#!/bin/bash
###########################
#Student ID:19054488
###########################

################################################################
# Start of comment block
################################################################
#Each function represents one subtask for the assessment
#You ***MUST*** place ***ALL*** code within the task function
################################################################
#If I had the follow task, as an example:
#"Display, to standard output, all the files with a 
#.java extension in present working directory"
#The function will look like:
#
#	function example_task {
#		ls *.java
#	}
#
#Another example task with function:
#"Prompt the user for a greeting, via standard output, and display
#the greeting via standard output"
#
#	function example_task_2 {
#		#this task uses examples from http://example.com
#		#to help read input
#		read -p "Please enter a greeting: " greeting
#		echo $greeting
#	}
#
#################################################################
#Delete the echo statements in each function when you start
#Remember, you will get an error if your function body is blank
#so leave the echo statement there until you are ready to work on
#the task.
#################################################################
#You are welcome to delete this comment block once you are happy
#with its instructions
#################################################################

#### task 1 ####
function task1_q1 {
echo "Hello Everyone!"
}

function task1_q2 {
read -p "Enter your name: " name
echo "Welcome, $name, to my Cyber Operations assesment"
}

function task1_q3 {
first_number=0
second_number=0
read -p "Enter the first number: " first_number
read -p "Enter the second number: " second_number
echo "$((first_number * second_number))"
}

function task1_q4 {
number=0
read -p "Enter the number between 1 and 100: " number
if [ $number -lt 50 ]
then
echo "Failed"
else
echo "Passed"
fi
}

function task1_q5 {
read  -p "Enter the filename: " file
if [ -e "$file" ]
then
        echo "File already exists"
else
        $(touch $file)
fi
}

#### task 2 ####
function task2_q1 {
read -p "Enter the directory name: " dir
$(chmod +x $dir/*.*)

list=$(find $dir -type f -name \*.txt| awk -F/ '{print $2}')
for file in $list;do
 echo $file
done
}

function task2_q2 {
read -p "Enter the file name: " file_name
list=$( grep "SERVER:" $file_name | sed 's/(/ /' | cut --delimiter=" " -f3)

for data in $list;do
        echo $data
done
}

function task2_q3 {
rm -f saved_domains.txt
input="urls.txt"
for i in $(cat $input);do
 read -p "Store $i (y or n): " value
 if [ $value == "y" ];then
  echo $i >> saved_domains.txt
 else
  continue
fi
done 
}

function task2_q4 {
rm -f loopback_ips.txt suspect_ips.txt temp.txt
input="ips.txt"
list=$((sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n $input)| uniq)

for i in $list;do
        echo $i >> temp.txt

done
for j in $(cat temp.txt);do
	 value=$(echo $j | cut -d "." -f1 )
        #echo $value
        if [ $value == "127" ];then
                echo "$j" >> loopback_ips.txt
        elif [[ $value == "162" || $value == "175" ]]
        then
                echo "$j" >> suspect_ips.txt
        else
                continue
        fi
done
rm -rf temp.txt
}

#### task 3 ####
function task3_q1 {
	rm -f emails.txt numbers.txt
grep -hrio '[A-Za-z]\+[\.A-Za-z0-9]*[a-z0-9]\+@[a-z0-9]\+\.[a-z]\+[\.A-Za-z0-9]\+' webpage.html | grep '[A-Za-z]\+[\.A-Za-z0-9]*@[a-z0-9]\+\.[a-z]\+$' | sort -u > emails.txt
grep -hro '[\(][0-9]\{5\}[\)][ ][0-9]\{6\}\|[0-9]\{5\}[ ][0-9]\{6\}\|[\(][0-9]\{5\}[\)][0-9]\{6\}' webpage.html | sed 's/)//g' |  sed 's/(//g' | sort -nu > numbers.txt
}

function task3_q2 {
	rm -f mid.txt averages.txt
set sum=0
for i in {1..10};do
sum=0
for j in {3..7};do
value=$(cut --delimiter=","  -f$j user-list.txt | tail -$i | head -1)
sum=$sum+$value
done
sum=$(echo $sum | bc)
#echo "Sum:$sum"
avg=$(echo $sum/5 |bc -l)
user_id=$(cut --delimiter="," -f2 user-list.txt | tail -$i | head -1)
echo "$avg,$user_id" >> mid.txt
$(cat mid.txt | sort -n > averages.txt)
done
rm -f mid.txt wednesday.txt
wsum=0
for i in {1..10};do
wvalue=$(cut --delimiter=","  -f5 user-list.txt | tail -$i | head -1)
wsum=$wsum+$wvalue
done
wsum=$(echo "$wsum" | bc)
wavg=$(echo $wsum/10 |bc -l)
echo $wavg > wednesday.txt
rm -f superuser.txt
#Average value for super users
for i in {1..10};do
ssum=0
suserid=$(sed 's/,User/ /' averages.txt | cut --delimiter=" " -f2 | tail -$i | head -1)
#echo $suserid
if [ $((suserid%2)) -eq 0 ]
then
svalue=$(cat averages.txt |cut --delimiter="," -f1 | tail -$i | head -1)
echo "User$suserid value:$svalue" >> superuser.txt
else
continue
fi
done
## To check the login users on Monday and order them
rm -f abc.txt tmp.txt login.txt
for i in {1..10};do
loggedinhrs=$(cut --delimiter=","  -f3 user-list.txt | tail -$i | head -1)
if [ $loggedinhrs -eq 0 ]
then
# username=$(cut --delimiter=","  -f2 user-list.txt | tail -$i | head -1)
# echo "User:$username not logged in on monday"
continue
else
details=$(cut --delimiter=","  -f2 user-list.txt | tail -$i | head -1)
echo $details >> abc.txt
fi
done
cat abc.txt | sed 's/User//' | sort -n > tmp.txt
for i in $(cat tmp.txt);do 
echo "User$i" >> login.txt
done
rm -f abc.txt tmp.txt
}

##### Execute your functions below this comment (do not delete this comment) ######

#task1_q1
#task1_q2
#task1_q3
#task1_q4
#task1_q5
#task2_q1
#task2_q2
#task2_q3
#task2_q4
#task3_q1
#task3_q2

######### DO NOT PUT ANYTHING BELOW THIS COMMENT ##########
