dir=$1

./parser.exe $dir/fixcub.time $dir/00fixcub.time
./parser.exe $dir/fixthrust.time $dir/00fixthrust.time
./parser.exe $dir/mergeseg.time $dir/00mergeseg.time
./parser.exe $dir/radixseg.time $dir/00radixseg.time
./parser.exe $dir/bbsegsort.time $dir/00bbsegsort.time

