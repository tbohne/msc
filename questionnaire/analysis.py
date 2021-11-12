#!/usr/bin/env python3
import argparse
from pathlib import Path

class LTAProblem:

    def __init__(self, name):
        self.name = name
        self.impact_votes = []
        self.difficulty_votes = []
        self.likelihood_votes = []

    def add_votes(self, impact, difficulty, likelihood):
        self.impact_votes.append(impact)
        self.difficulty_votes.append(difficulty)
        self.likelihood_votes.append(likelihood)

    def __str__(self):
        return "impact: " + str(self.impact_votes) + "\ndifficulty:" + str(self.difficulty_votes) + "\nlikelihood:" + str(self.likelihood_votes) + "\n"
    

def generate_accumulated_results(directory):
    pathlist = Path(directory).rglob('*.csv')
    lta_problems = {}
    for path in pathlist:
        file = str(path)
        print("#######################################")
        print("processing", file)

        with open(file, 'r') as f:
            for l in f.readlines()[1:]:
                problem, impact, difficulty, likelihood = l.strip().split(",")
                if problem not in lta_problems.keys():
                    lta_problems[problem] = LTAProblem(problem)
                lta_problems[problem].add_votes(impact, difficulty, likelihood)

    for key, value in lta_problems.items():
        print("problem:", key)
        print("res:", value)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='analyze results of questionnaire')
    parser.add_argument('-i', '--input', help='input file', required=True)
    args = vars(parser.parse_args())
    generate_accumulated_results(args['input'])
