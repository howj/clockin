import csv
import json

'''
Sample code showing how to read + write csv style files
'''

# Read in the sql output to do further processing
input_filename = "input.csv"
with open(input_filename, 'r') as infile:
    csv_reader = csv.reader(infile, delimiter='\t', quotechar="'", quoting=csv.QUOTE_NONE, lineterminator='\n', escapechar='\\')
    row_index = 0
    for row in csv_reader:
        # Skip the header row
        if row_index != 0:
            # Do stuff with the rows, column data is at the index in the row
            column_data_a = row[0]
            column_data_b = row[1]

            # If examining the start/end/action details data blob, parse with json
            if row[2] is not None:
                details_data_blob = json.loads(row[2])
                my_custom_value = details_data_blob['my_custom_prop']

        row_index += 1

# Output transformed data back into another csv
output_filename = "new_output.csv"
with open(output_filename, 'w') as outfile:
    # Making this tab-delimited to be consistent with the format coming from the sql output
    csv_writer = csv.writer(out_file, delimiter='\t', quotechar="'", quoting=csv.QUOTE_NONE, lineterminator='\n', escapechar='\\')
    header_columns = ['col1', 'col2', 'col3']
    csv_writer.writerow(header_columns)

    # Add the data later
    csv_writer.writerow(['data1', 'data2', 'data3'])

    # Flush the changes to save to the file
    outfile.flush()
