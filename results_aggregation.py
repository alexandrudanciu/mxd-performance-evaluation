import json
import matplotlib.pyplot as plt # to install: pip3 install plotly
import numpy as np
import mplcursors  # to install: pip3 install mplcursors
import os

############ Required Input ############
root_folder = './Ergebnisse'
values = ['meanResTime', 'sampleCount']
processes = ['Get Transfer State', 'Initiate Transfer']

######################################################################################
# A function for extracting values from a given file
def extract_values(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    values = {}
    for line in lines:
        if 'OEM_PLANTS' in line:
            values['OEM_PLANTS'] = int(line.split('=')[1].strip())
        elif 'OEM_CARS_INITIAL' in line:
            values['OEM_CARS_INITIAL'] = line.split('=')[1].strip()
    return values

# List comprehension to gather all directories under the specified root_folder
directories = [os.path.join(root_folder, o) for o in os.listdir(root_folder) 
    if os.path.isdir(os.path.join(root_folder,o))]

# Iterates over each action and value from the lists and creates a new figure for each combination
for action_to_consider in processes:
    for value_idx, value in enumerate(values):
        plt.figure(figsize=(15, 4))
        plt.title('Aggregation of Performance Test Results: {} for {}'.format(value, action_to_consider))

        stats = []
        labels = []

        # Goes through each directory to find the metadata and statistics files
        for idx, directory in enumerate(directories):
            metadata_path = os.path.join(directory, 'metadata.txt')  
            statistics_path = os.path.join(directory, 'dashboard/statistics.json')  
            
            # If both files exist in the directory, it calls the function to extract values from the metadata file
            if os.path.exists(metadata_path) and os.path.exists(statistics_path):
                meta_values = extract_values(metadata_path)

                # Opens the statistics.json file and loads its content
                with open(statistics_path, 'r') as f:
                    stats_data = json.load(f)

                # appends the statistics for each action and the associated labels for the plot
                action = stats_data[action_to_consider]
                stats.append((meta_values['OEM_PLANTS'], action[value]))
                labels.append('Plants: {}, Cars: {}'.format(meta_values['OEM_PLANTS'], meta_values['OEM_CARS_INITIAL']))

        # plots the statistics data as a line plot and a scatter plot
        plt.plot([s[0] for s in stats], [s[1] for s in stats])
        plt.scatter([s[0] for s in stats], [s[1] for s in stats], color='red')

        # adds labels to each point on the scatter plot (that x-axis matches OEM_PLANTS values)
        for i, text in enumerate(labels):
            plt.text(stats[i][0], stats[i][1], text)

        plt.xlabel('OEM_PLANTS')
        plt.ylabel(value)
        plt.show()