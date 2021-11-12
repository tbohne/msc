#!/usr/bin/env python3
import argparse
from pathlib import Path

def generate_accumulated_results(directory):
    pathlist = Path(directory).rglob('*.csv')
    for path in pathlist:
        file = str(path)
        print("#######################################")
        print("processing file: %s", file)

        with open(file, 'r') as f:
            for l in f.readlines()[1:]:
                print(l.strip())

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='analyze results of questionnaire')
    parser.add_argument('-i', '--input', help='input file', required=True)
    args = vars(parser.parse_args())
    generate_accumulated_results(args['input'])
