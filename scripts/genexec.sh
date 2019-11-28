#!/bin/bash
out=$1
generator=$2

echo "" > $out/bbsegsort.time
echo "" > $out/mergeseg.time
echo "" > $out/radixseg.time
echo "" > $out/fixcub.time
echo "" > $out/fixthrust.time			
	

n=32768
while [ $n -le 134217728 ]
do
	s=1
	while [[ $s -lt $n && $s -le 1048576 ]] 
	do
		echo -e "\n"$s"\n"$n >> $out/bbsegsort.time
		echo -e "\n"$s"\n"$n >> $out/mergeseg.time
	  	echo -e "\n"$s"\n"$n >> $out/radixseg.time
		echo -e "\n"$s"\n"$n >> $out/fixcub.time
		echo -e "\n"$s"\n"$n >> $out/fixthrust.time			
		
		i=1
		while [ $i -le  10 ] 
		do
			in=$s"_"$n"_"$i".in"
			./$generator $s $n > $in

			./bbsegsort/bbsegsort.exe 	< $in 	>> $out/bbsegsort.time
			./mergeseg.exe 			< $in 	>> $out/mergeseg.time
			./radixseg.exe 			< $in 	>> $out/radixseg.time
			./fixcub.exe 			< $in 	>> $out/fixcub.time
			./fixthrust.exe 		< $in	>> $out/fixthrust.time			

			rm -f $in
			((i=$i+1))
		done
		((s=$s*2))
		
	done
	((n=$n*2))
done
