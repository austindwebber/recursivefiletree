#!/bin/bash
#Recursive File Tree
#Developed by Austin Webber, UWRF 
#2/14/19
tree () {
for i in `echo *` #List files/directories in current depth
do
  if [ -d "$i" ] ; then
  t=0 #Keep track of directory #
  while [ $t != $1 ]; #Loop until all directories have been searched
    do
      echo -n "|  " #Apply structure for each line
      ((t++))
    done
    echo "|-- $i" #Apply structure for each directory
    ((nd++))
    if cd "$i" ; then #Change to next directory
      tree `expr $1 + 1` #Execute recursive function
      files=(`find . -maxdepth 1 -type f | sort -d | cut -c 3-`) #List all files in current directory
      if ! [ -z "$files" ]; then #Only print filenames, if files exist
        if [ "${#files[@]}" -ge "1" ]; then 
          for a in "${files[@]::${#files[@]}-1}" #Print all values in array, except last value
            do
	    if [ "$t" -ge "1" ]; then #Print extra spaces based on current directory location
	      printf "%0.s|  " $(seq 1 $t) #Based on depth
	    fi 
            echo "|  |-- $a" #Print filenames
            ((nf++))
          done
        fi
        if [ "$t" -ge "1" ]; then #Print extra spaces based on current directory location
          printf "%0.s|  " $(seq 1 $t) #Based on depth
	  echo "|  \`-- ${files[-1]}" #Print last value
        else 
          echo "|  \`-- ${files[-1]}" #Print last value
        fi
      fi
      ((nf++))
      cd ..
      ((t--))
    fi
  fi
done
} #End of tree()
if [ $# != 0 ]; then #If an argument is specified, change to that directory
    cd $1 2> /dev/null
    echo $1
else
    echo "`basename $PWD`"
fi
#Setup variables
startd=`pwd`
nd=0
nf=0
#Execute Tree
tree 0

#Print all root directory files
cd $startd
files=(`find . -maxdepth 1 -type f | sort -d | cut -c 3-`) #Find all files in current directory
if ! [ -z "$files" ]; then #Only print filenames, if files exist
  if [ "${#files[@]}" -ge "1" ]; then 
    for a in "${files[@]::${#files[@]}-1}"; #Loop through files in current directory
      do
        echo "|-- $a"
        ((nf++))
      done
    echo "\`-- ${files[-1]}"
  else
    echo "\`-- ${files[-1]}"
  fi
((nf++))
fi
echo "$nd directories, $nf files" #Print amount of files & directories


#Developed by Austin Webber, UWRF
