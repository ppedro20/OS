#!/bin/bash

set -u


function validateFile() {

   #To validate the file first we need to check if the file exists

   if [[ ! -f $file ]]; then
      
      echo "The input file does not exist"
      exit

   #Then its necessary to verify the extension of the file so just .pdf and .txt files are accepted

   elif [[ "$file" != *.pdf ]] && [[ "$file" != *.txt ]]; then

      echo "The input file is not a pdf or a txt file" 
      exit
   
   fi

}


function removeStopWords(){
   #In this case we are verifying if the lang input its valid 
   grep -vwFf ./StopWords/"$lang".stop_words.txt "$file_location"/processing"$file_name".txt  > "$file_location"/processing2"$file_name".txt
   mv "$file_location"/processing2"$file_name".txt "$file_location"/processing"$file_name".txt

}

#Validate the file input so the user cant specifie a non existing file

#Verifying if the cardinality of inputs are not equal to 3, if not an error message is shown to the user

if [[ $# -ne 3 ]];then 
   echo "The inputs are not correct $0 [mode] [file location] [lang]"

elif  [[ "${1^^}" != +('C'*|'P'*|'T'*) ]];then
   echo "The only supported modes are C/c, P/p, T/p"

elif  [[ $3 != "en" ]] && [[ $3 != "pt" ]];then
   echo "Invalid language option"

else

mode=$1
file=$2
file_location="$(dirname "$2")"
file_name="$(basename "${2%.*}")"
lang=$3

validateFile

   #We will convert the file to txt just when the input file its and pdf

	if [[ "$file" == *.pdf ]];then

		pdftotext "$file"

	fi

   #Here in the first place we are removing all the numbers from the txt file then converting all the upper characters to lower and then saving it in a temporary file 

	tr -d "0-9" < "$file_location"/"$file_name".txt | grep -oE '\w+' | tr '[:upper:]' '[:lower:]' > "$file_location"/processing"$file_name".txt


   #Verifying if the user wants to remove the StopWords
   if [[ $mode == "c"* ]] || [[ $mode == "p"* ]] || [[ $mode == "t"* ]]; then

      removeStopWords

   fi

   #To verify just the upper letter in the next switch case we convert the input "mode" field to upper
   mode="${mode^^}"

   case $mode in

   #If the user misses a letter when stating the "mode" the script will just verify the first letter

   "C"*)
      sort < "$file_location"/processing"$file_name".txt | uniq -c | sort -nr | nl > "$file_location"/result---"$file_name".txt
      ;;

   "P"*)
      
      ;;

   "T"*)
      
      ;;

   *)
      echo "Invalid Option"
      ;;
   esac
