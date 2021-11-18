#!/usr/bin/env python3
import argparse
from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

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

    def get_impact(self):
        return np.average(self.impact_votes)

    def get_difficulty(self):
        return np.average(self.difficulty_votes)

    def get_likelihood(self):
        return np.average(self.likelihood_votes)

    def compute_dist_to_optimum(self):
        x_opt = 1
        y_opt = 1
        z_opt = 1
        x_actual = self.get_impact()
        y_actual = self.get_difficulty()
        z_actual = self.get_likelihood()
        return np.sqrt((x_actual - x_opt) ** 2 + (y_actual - y_opt) ** 2 + (z_actual - z_opt) **2)

    def __str__(self):
        return "problem: " + self.name + "\nimpact: " + str(self.get_impact()) + " - (" + str(self.impact_votes) + ")\ndifficulty: " \
            + str(self.get_difficulty()) + " - (" + str(self.difficulty_votes) + ")\nlikelihood: " + str(self.get_likelihood()) \
            + " - (" + str(self.likelihood_votes) + ")\ndist. to optimum: " + str(self.compute_dist_to_optimum()) + "\n"


def plot(lta_problems):
    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')

    ax.set_xlim3d(3, 1)
    ax.set_ylim3d(1, 3)
    ax.set_zlim3d(1, 3)

    impact_votes = []
    difficulty_votes = []
    likelihood_votes = []
    names = []

    for _, problem in lta_problems.items():
        names.append(problem.name)
        impact_votes.append(problem.get_impact())
        difficulty_votes.append(problem.get_difficulty())
        likelihood_votes.append(problem.get_likelihood())

    s = [500 for n in range(len(names))]

    ax.scatter(impact_votes, difficulty_votes, likelihood_votes, marker='D', color='red', s=s, label='PM: power_management\nCF: charging_failure\nDW: drastic_weather_change\nCD: certain_dynamics\nSF: sensor_failure\nPA: perceptual_aliasing_issue\nDM: data_management\nLC: lost_connection\nOB: obstacles_blocking_path\nRS: robot_gets_stuck\nRF: robot_falls_over\nNF: navigation_failure\nSR: sustained_recovery\nIL: incorrect_localization\nME: mapping_error\nPF: plan_deployment_failure')
    ax.scatter(1, 1, 1, marker='X', color='gold', s=[500])

    for i, problem in enumerate(names):
        ax.text(impact_votes[i], difficulty_votes[i], likelihood_votes[i], problem, fontsize=15)
    ax.text(1, 1, 1, 'optimum', fontsize=15)

    ax.set_xlabel('impact (1: high, 2: medium, 3: low)', fontsize=15)
    ax.set_ylabel('difficulty (1: easy, 2: medium, 3: hard)', fontsize=15)
    ax.set_zlabel('likelihood (1: very likely, 2: occurs, 3: highly unlikely', fontsize=15)
    
    ax.legend(loc='upper left', fontsize=15)
    plt.show()
    

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

    plot(lta_problems)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='analyze results of questionnaire')
    parser.add_argument('-i', '--input', help='input file', required=True)
    args = vars(parser.parse_args())
    generate_accumulated_results(args['input'])
