#!/bin/bash
#set -x

# Version 0.7
# This script launches a fake load on each and every 
# core of a Linux system (x86-64).
#
# NOTE: It has been tested succesfully on a 8Blade/480 logical cores
# DragonHawk system.
#
# REQUIREMENTS:
#
# * Both the executable and the script launcher must be in the same directory
# * The executable and script launcher must have the same radical name
# * The script launcher has the ".sh"  suffix extension
# The demo fake loader generates a random load during about 
# seconds.
#
# Collectl possible monitoring command:
# collectl -sZ -i5:6 --procfilt cfake_loader --hr 1
###############################################################################


# ARGS
MIN_NARGS=0
MAX_NARGS=2



# Get launcher name from command line,
# remove the .sh suffix to get the executable name
LAUNCHER=$0
EXEC=${LAUNCHER%%.sh}

# Obtain the number of cores in the system
NUM_CPU=`/usr/bin/lscpu | awk '/^CPU\(s\)/ {print $NF}'`

#NUM_CPU=10

# Compute a sleep duration to have a somehow stable load in the sytem
DEMO_DURATION=20
SLEEP_TIME=$((($DEMO_DURATION - ($NUM_CPU % $DEMO_DURATION)) + $DEMO_DURATION))



#
# Functions
#

function usage () {
        echo "Usage: "
        echo "$0 [NUM_CPU [SLEEP_TIME]] "
        echo "Where NUM_CPU is the number of cores to launch $EXEC on."
        echo "where  SLEEP_TIME is the time to wait before launching the load agin. A small value will create more load in the system. Default is 20 seconds."
        echo ""
}


case $# in
   0) 
     ;;
   1)
     NUM_CPU=$1
     ;;

   2) 
     NUM_CPU=$1
     SLEEP_TIME=$2
     ;;
   *)
    echo "Wrong number of arguments."
    echo 
    usage
    exit 3
esac



# Debug:
#echo "NUM_CPU: $NUM_CPU" 
#echo "SLEEP_TIME: $SLEEP_TIME" 


# Endless loop: launch the loader on each core and sleep for a while
echo "Starting a $EXEC process on $NUM_CPU CPUs" 
while true ; do
  c=0
  while [ $c -lt  $NUM_CPU ] ; do
   #echo "c: $c" 
   /bin/taskset -c $c $EXEC > /dev/null 2>&1 & 
   sleep 2 
   let c++
  done
  #echo "Sleep for $SLEEP_TIME seconds..." 
  sleep $SLEEP_TIME 
done
