#!/bin/bash
###############################################################################
# Examples:                                                                   #
#   ./run_experiment.sh                                                       #
#   ./run_experiment.sh -t M                                                  #
#   ./run_experiment.sh -q L                                                  #
#   ./run_experiment.sh -t T -q S                                             #
#                                                                             #
# Command Line Options:                                                       #
# -t : Jmeter Script to execute [Optional]                                    #
#      Options:                                                               #
#        S -> setup.jmx                                                       #
#        M -> measurement_interval.jmx                                        #
#        T -> tear_down.jmx                                                   #
#      Default:                                                               #
#        Execute all scripts in order S, M and T.                             #
#                                                                             #
# -q : Jmeter Properties [Optional]                                           #
#      Options:                                                               #
#        S -> small_experiment.properties                                     #
#        M -> medium_experiment.properties                                    #
#        L -> large_experiment.properties                                     #
#      Default:                                                               #
#        S                                                                    #
#                                                                             #
###############################################################################

declare -A jmeter_scripts=( ["S"]="setup.jmx"
                            ["M"]="measurement_interval.jmx"
                            ["T"]="tear_down.jmx")

declare -A properties_map=( ["S"]="small_experiment.properties"
                            ["M"]="medium_experiment.properties"
                            ["L"]="large_experiment.properties")

jmeter_script_opt=""
experiment_property_opt="S"

while getopts t:q: flag
do
    case "${flag}" in
        t) jmeter_script_opt=${OPTARG};;
        q) experiment_property_opt=${OPTARG};;
    esac
done

jmeter_script=""
if [ -n "$jmeter_script_opt" ]; then
  jmeter_script="${jmeter_scripts[$jmeter_script_opt]}"
fi
experiment_property="${properties_map[$experiment_property_opt]}"

if [ -z "$JMETER_HOME" ]; then
  echo "JMETER_HOME is not defined - please define it."
  exit 1  
fi
echo "Jmeter found at path $JMETER_HOME"

jmeter_binary="$JMETER_HOME/bin/jmeter"

rm -rf output
mkdir -p output/dashboard

echo "*** Property: $experiment_property Start ***"
cat $experiment_property
echo "*** Property: $experiment_property End ***"

echo "*** Performance Test Start ***"
if [ -z "$jmeter_script" ]; then
  echo "Executing all scripts in order S, M && T"
  $jmeter_binary -n -t setup.jmx -l output/setup.jtl -q experiment_property
  $jmeter_binary -n -t measurement_interval.jmx -l output/measurement_interval.jtl -q experiment_property -e -o output/dashboard
  $jmeter_binary -n -t tear_down.jmx -l output/tear_down.jtl -q experiment_property
else
  echo "Executing script: $jmeter_script"
  $jmeter_binary -n -t $jmeter_script -l output/measurement_interval.jtl -q experiment_property -e -o output/dashboard
fi
echo "*** Performance Test End ***"

echo "Creating tar file with output"
tar -cf output.tar output

echo "*** Test Completed..., Sleeping now ***"
while true; do sleep 10000; done
