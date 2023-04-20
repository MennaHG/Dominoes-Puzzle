with open('results.txt', 'r') as input_file:
    strings = input_file.read().split('\n')

unique_strings = list(set(strings))

with open('output_file.txt', 'w') as output_file:
    for string in unique_strings:
        output_file.write(string + '\n')
