#!/usr/bin/env python3
import argparse
from pathlib import Path
import numpy as np

class LTAProblem:

    def __init__(self, name):
        self.name = name
        self.impact_votes = []
        self.difficulty_votes = []
        self.likelihood_votes = []

    def add_votes(self, ratings):
        """
        0 -> no oppinion -> ignore in results
        """
        if ratings[0] != 0:
            self.impact_votes.append(ratings[0])
        if ratings[1] != 0:
            self.difficulty_votes.append(ratings[1])
        if ratings[2] != 0:
            self.likelihood_votes.append(ratings[2])

    def __str__(self):
        return "problem: " + self.name + "\nimpact: " + str(np.average(self.impact_votes)) + " - (" + str(self.impact_votes) + ")\ndifficulty: " \
            + str(np.average(self.difficulty_votes)) + " - (" + str(self.difficulty_votes) + ")\nlikelihood: " + str(np.average(self.likelihood_votes)) \
            + " - (" + str(self.likelihood_votes) + ")\n"
    

def generate_accumulated_results(directory):
    pathlist = Path(directory).rglob('*.csv')
    lta_problems = {}
    for path in pathlist:
        file = str(path)
        print("#######################################")
        print("processing", file)

        with open(file, 'r') as f:
            for l in f.readlines()[1:]:
                vals = l.strip().split(",")
                problem = vals[0]
                ratings = vals[1:]
                if problem not in lta_problems.keys():
                    lta_problems[problem] = LTAProblem(problem)
                lta_problems[problem].add_votes([int(i) for i in ratings])

    for _, problem in lta_problems.items():
        print(problem)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='analyze results of questionnaire')
    parser.add_argument('-i', '--input', help='input file', required=True)
    args = vars(parser.parse_args())
    generate_accumulated_results(args['input'])
