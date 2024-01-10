#!/bin/bash

if [ -z "$JMETER_HOME" ]; 
then
  echo "JMETER_HOME is not defined - please define it."
  exit 1  
fi

echo "Jmeter found at path $JMETER_HOME"
chmod +x run_experiment.sh
jmeter_bin="$JMETER_HOME/bin/jmeter"

jmeter_files=("setup.jmx" "measurement_interval.jmx" "tear_down.jmx")

if [ -z "$1" ]; then
    echo "Please define the scope of the test execution by specifying the .properties file (S = small_experiment.properties, M = medium_experiement.properties and L = large_experiment.properties)"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please define the phase of the test execution by specifying the JMeter script (S = setup.jmx, M = measurement_interval.jmx, T = tear_down.jmx and SMT = Sequential execution of all scripts)"
    exit 1
fi

if [ "$1" = "S" ] && [ "$2" = "S" ]; then
    $jmeter_bin -n -t setup.jmx -l test_summary.jtl -q small_experiment.properties -e -o report
    echo "Executing setup.jmx with the properties of small_experiment.properties"
elif [ "$1" = "S" ] && [ "$2" = "M" ]; then
    $jmeter_bin -n -t measurement_interval.jmx -l test_summary.jtl -q small_experiment.properties -e -o report
    echo "Executing measurement.jmx with the properties of small_experiment.properties"
elif [ "$1" = "S" ] && [ "$2" = "T" ]; then
    $jmeter_bin -n -t tear_down.jmx -l test_summary.jtl -q small_experiment.properties -e -o report
    echo "Executing tear_down.jmx with the properties of small_experiment.properties"
elif [ "$1" = "S" ] && [ "$2" = "SMT" ]; then
    for file in "${jmeter_files[@]}"
    do
        echo "Executing JMeter script: $file"
        $jmeter_bin -n -t $file -l test_summary.jtl -q medium_experiment.properties -e -o report
    done
elif [ "$1" = "M" ] && [ "$2" = "S" ]; then
    $jmeter_bin -n -t setup.jmx -l test_summary.jtl -q medium_experiment.properties -e -o report
    echo "Executing setup.jmx with the properties of medium_experiment.properties"
elif [ "$1" = "M" ] && [ "$2" = "M" ]; then
    $jmeter_bin -n -t measurement_interval.jmx -l test_summary.jtl -q medium_experiment.properties -e -o report
    echo "Executing measurement.jmx with the properties of medium_experiment.properties"
elif [ "$1" = "M" ] && [ "$2" = "T" ]; then
    $jmeter_bin -n -t tear_down.jmx -l test_summary.jtl -q medium_experiment.properties -e -o report
    echo "Executing tear_down.jmx with the properties of medium_experiment.properties"
elif [ "$1" = "M" ] && [ "$2" = "SMT" ]; then
    for file in "${jmeter_files[@]}"
    do
        echo "Executing JMeter script: $file with the properties of medium_experiment.properties"
        $jmeter_bin -n -t $file -l test_summary.jtl -q medium_experiment.properties -e -o report
    done
elif [ "$1" = "L" ] && [ "$2" = "S" ]; then
    $jmeter_bin -n -t setup.jmx -l test_summary.jtl -q large_experiment.properties -e -o report
    echo "Executing setup.jmx with the properties of large_experiment.properties"
elif [ "$1" = "L" ] && [ "$2" = "M" ]; then
    $jmeter_bin -n -t measurement_interval.jmx -l test_summary.jtl -q large_experiment.properties -e -o report
    echo "Executing measurement.jmx with the properties of large_experiment.properties"
elif [ "$1" = "L" ] && [ "$2" = "T" ]; then
    $jmeter_bin -n -t tear_down.jmx -l test_summary.jtl -q large_experiment.properties -e -o report
    echo "Executing tear_down.jmx with the properties of large_experiment.properties"
elif [ "$1" = "L" ] && [ "$2" = "SMT" ]; then
    for file in "${jmeter_files[@]}"
    do
        echo "Executing JMeter script: $file with the properties of large_experiment.properties"
        $jmeter_bin -n -t $file -l test_summary.jtl -q large_experiment.properties -e -o report
    done
else
    echo "Please enter valid values!"
fi