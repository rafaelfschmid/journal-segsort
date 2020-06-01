timeDir=$1 # passar o modelo da gpu (sem espaço)

mkdir -p ../times/equal/$timeDir
./../scripts/genexec.sh ../times/equal/$timeDir ../utils/equal.exe
./../scripts/genexec.sh ../times/diff/$timeDir ../utils/diff.exe

