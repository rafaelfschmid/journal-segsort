cfg=$1
cfgfile="config_environment-${cfg}.sh"

if [ "${cfg}x" == "x" ]; then
    echo "ERROR: you must provide a configuration name."
    echo "Usage: $0 configname"
    echo "There must exist a file configure_environment-configname.sh on the base directory"
    exit 1
fi

if [ ! -f "${cfgfile}" ]; then
    echo "ERROR: ${cfgfile} script is missing"
    exit 1
fi

cfglogdir="logs/${cfg}"
mkdir -p "${cfglogdir}"
DT=`date "+%Y-%m-%d-%H-%M-%S"`
cfglog="${cfglogdir}/run-${DT}"
echo "" > "${cfglog}" # Clean log file

echo "Redirecting all outputs to log file: ${cfglog}"


function report {
    echo "$@"
    echo "$@" >> "${cfglog}"
}

function fail {
    report "FAIL: $@"
    D=`date`
    report "Failure time: $D"
    exit 1
}

D=`date`
report "Start time: $D"

source "${cfgfile}" &>> "${cfglog}" || fail "Error when sourcing configuration script \"${cfgfile}\""

# Try to read the devices informatin
report "1-Reading devices..."
report "lscpi | grep -i nvidia"
lspci | grep -i nvidia &>> "${cfglog}"
if [ -f utils/deviceQuery ]; then
    report "./utils/deviceQuery"
    ./utils/deviceQuery &>> "${cfglog}"
fi

# Build utils
report "2-Building utils..."
(cd utils && make || fail "Could not build utils") &>> "${cfglog}"

# Build sorting apps
report "3-Building sorting apps..."
(cd src && make || fail "Could not build utils")  &>> "${cfglog}"
(cd src/bbsegsort && make || fail "Could not build utils")  &>> "${cfglog}"

# Build sorting apps
report "4-Executing benchmark..."
mkdir -p "./times/${cfg}-${DT}/equal/" || fail "Could not create directory ./times/${cfg}-${DT}/equal"
mkdir -p "./times/${cfg}-${DT}/diff/" || fail "Could not create directory ./times/${cfg}-${DT}/diff"

(cd ./src && ../scripts/genexec.sh "../times/${cfg}-${DT}/equal" ../utils/equal.exe &>> "../${cfglog}") \
    || fail "Error when executing benchmarks: equal"

(cd ./src && ../scripts/genexec.sh "../times/${cfg}-${DT}/diff" ../utils/diff.exe &>> "../${cfglog}") \
    || fail "Error when executing benchmarks: diff"

report "5-Execution finished without errors"

D=`date`
report "End time: $D"
