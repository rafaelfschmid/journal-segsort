prog=$1 #program to run
input=$2 #input files dir

n=32768
while [[ $n -le 134217728 ]]
do
	for ((s=1; s<=1048576; s*=2))
	do
		if [ $s == $n ]
		then
			break;
		fi
	
        	echo " "
		echo ${s}
		echo ${n}

		for b in `seq 1 10`; do
			./$prog < $input/${s}_${n}_${b}.in
		done
		rm 
        done
	((n=$n*2))
done

