FROM justb4/jmeter:5.5

WORKDIR $JMETER_HOME/mxd-performance-evaluation

COPY . .

ENTRYPOINT ["./run_experiment.sh"]
