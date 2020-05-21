#!/bin/bash
out=$1
generator=$2

#echo "" > $out/newthrust32thr.time		
#echo "" > $out/newthrust32schedthr.time		
echo "" > $out/nthrust.time		

n=32768
while [ $n -le 134217728 ]
do
	s=1
	while [[ $s -lt $n && $s -le 2048 ]] 
	do

		#echo -e "\n"$s"\n"$n >> $out/newthrust32thr.time
		#echo -e "\n"$s"\n"$n >> $out/newthrust32schedthr.time
		echo -e "\n"$s"\n"$n >> $out/nthrust.time

		i=1
		while [ $i -le  10 ] 
		do
			in=$s"_"$n"_"$i".in"
			./$generator $s $n > $in

#			./newthrust32thr.exe 	< $in 	>> $out/newthrustthr.time
#			./newthrust32schedthr.exe	< $in	>> $out/newthrustschedthr.time
			./nthrust.exe		< $in	>> $out/nthrust.time				
			
			rm -f $in
			((i=$i+1))
		done
		((s=$s*2))
		
	done
	((n=$n*2))
done
