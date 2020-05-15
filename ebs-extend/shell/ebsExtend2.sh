# value is the space available in the disk
# result is the calculation to find the percentage of space left in the disk
# getting the disk space available with the custom aws cloudwatch metrics
# ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path=/ebs --disk-space-avail --verbose > /ebs/ebsavailable.txt

# outputting the first line to a separate file
# head -1 /ebs/ebsavailable.txt > /ebs/shortEbsUsed.txt
head -1 ./ebsavailable.txt > ./shortEbsUsed.txt

# getting the number value
value=`cat shortEbsUsed.txt | sed 's/.*: //' | cut -d " " -f 1`
echo $value

#calculation logic
result=`echo "100 - (( $value / 30 ) * 100)" | bc -l`
echo $result

threshold=80
gt=$(echo "$result > $threshold" | bc -q )
# return 1 if true ; O if not
if [ $gt = 1 ]
then
   echo "call lambda"
else
   echo "do nothing"
fi