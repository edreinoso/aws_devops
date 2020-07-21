logic=false
value="data"
n=0

# testing code
# ((n+=1))
# echo $n

# value="$value$n"
# logic=true
# echo $value $logic

while [ "$logic" ]
do
    x=`ls / | grep $value`
    # mkdir 
    if [[ -z  $x ]]; then
        echo "Hello World"
        sudo mkdir /$value
        logic=true
    else
        ((n+=1)) #sum operations
        value="data"
        value="$value$n" # assigning new value
    fi
done