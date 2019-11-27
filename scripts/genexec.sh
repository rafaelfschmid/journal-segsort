#!/bin/bash
out=$1
generator=$2

echo "" > $out/bbsegsort.time
echo "" > $out/mergeseg.time
echo "" > $out/radixseg.time
echo "" > $out/fixcub.time
echo "" > $out/fixthrust.time			
	

c=32768
while [ $c -le 134217728 ]
do
	#echo $c 
	d=1
	while [[ $d -lt $c && $d -le 1048576 ]] 
	do
		echo -e "\n"$d"\n"$c >> $out/bbsegsort.time
		echo -e "\n"$d"\n"$c >> $out/mergeseg.time
	  	echo -e "\n"$d"\n"$c >> $out/radixseg.time
		echo -e "\n"$d"\n"$c >> $out/fixcub.time
		echo -e "\n"$d"\n"$c >> $out/fixthrust.time			
		
		i=1
		while [ $i -le  10 ] 
		do
			in=$d"_"$c"_"$i".in"
			./$generator $d $c > $in

			./bbsegsort/bbsegsort.exe 	< $in 	>> $out/bbsegsort.time
			./mergeseg.exe 			< $in 	>> $out/mergeseg.time
			./radixseg.exe 			< $in 	>> $out/radixseg.time
			./fixcub.exe 			< $in 	>> $out/fixcub.time
			./fixthrust.exe 		< $in	>> $out/fixthrust.time			

			rm -f $in
			((i=$i+1))
		done
		((d=$d*2))
		
	done
	((c=$c*2))
done
