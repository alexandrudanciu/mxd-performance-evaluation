#!/bin/bash

if [ -z "$JMETER_HOME" ]; 
then
  echo "JMETER_HOME is not defined - please define it."
  exit 1  
fi

echo "Jmeter found at path $JMETER_HOME"

chmod +x run_experiment.sh

jmeter_files=("setup.jmx" "measurement_interval.jmx" "tear_down.jmx")

jmeter_bin="$JMETER_HOME/bin/jmeter"

# Iteration über die JMeter-Dateien
for file in "${jmeter_files[@]}"
do
    echo "Executing JMeter script: $file"
    $jmeter_bin -n -t $file -l "test_summary.json" -q experiment.properties
done