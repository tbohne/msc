#!/usr/bin/env python3
import argparse
from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt

LABELS = 'PM: power_management\nCF: charging_failure\nDW: drastic_weather_change\nCD: certain_dynamics\n' \
         + 'SF: sensor_failure\nPA: perceptual_aliasing_issue\nDM: data_management\nLC: lost_connection\n' \
         + 'OB: obstacles_blocking_path\nRS: robot_gets_stuck\nRF: robot_falls_over\nNF: navigation_failure\n' \
         + 'SR: sustained_recovery\nIL: incorrect_localization\nME: mapping_error\nPF: plan_deployment_failure'


class LTAProblem:

    def __init__(self, name):
        self.name = name
        self.impact_votes = []
        self.difficulty_votes = []
        self.likelihood_votes = []

    def add_votes(self, ratings):
        # 0 -> no opinion -> ignore in results
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

    def compute_dist_to_optimum_3d(self):
        x_opt = y_opt = z_opt = 1
        x_actual = self.get_impact()
        y_actual = self.get_difficulty()
        z_actual = self.get_likelihood()
        return np.sqrt((x_actual - x_opt) ** 2 + (y_actual - y_opt) ** 2 + (z_actual - z_opt) ** 2)

    def compute_dist_to_optimum_2d(self):
        x_opt = y_opt = 1
        x_actual = self.get_impact()
        y_actual = self.get_likelihood()
        return np.sqrt((x_actual - x_opt) ** 2 + (y_actual - y_opt) ** 2)

    def __str__(self):
        return "problem: " + self.name + "\nimpact: " + str(self.get_impact()) + " - (" + str(self.impact_votes) \
               + ")\ndifficulty: " + str(self.get_difficulty()) + " - (" + str(self.difficulty_votes) \
               + ")\nlikelihood: " + str(self.get_likelihood()) + " - (" + str(self.likelihood_votes) \
               + ")\ndist. to optimum (3D): " + str(self.compute_dist_to_optimum_3d()) \
               + "\ndist. to optimum (2D): " + str(self.compute_dist_to_optimum_2d()) + "\n"


def plot_3d(lta_problems):
    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')
    ax.set_xlim3d(3, 1)
    ax.set_ylim3d(1, 3)
    ax.set_zlim3d(1, 3)
    impact_votes, difficulty_votes, likelihood_votes, names = ([] for _ in range(4))

    for _, problem in lta_problems.items():
        names.append(problem.name)
        impact_votes.append(problem.get_impact())
        difficulty_votes.append(problem.get_difficulty())
        likelihood_votes.append(problem.get_likelihood())

    s = [500 for _ in range(len(names))]
    ax.scatter(impact_votes, difficulty_votes, likelihood_votes, marker='D', color='g', s=s, label=LABELS)
    ax.scatter(1, 1, 1, marker='X', color='gold', s=[500])

    for i, problem in enumerate(names):
        ax.text(impact_votes[i], difficulty_votes[i], likelihood_votes[i], problem, fontsize=15)
    ax.text(1, 1, 1, 'optimum', fontsize=15)

    ax.set_xlabel('impact (1: high, 2: medium, 3: low)', fontsize=15)
    ax.set_ylabel('difficulty (1: easy, 2: medium, 3: hard)', fontsize=15)
    ax.set_zlabel('likelihood (1: very likely, 2: occurs, 3: highly unlikely', fontsize=15)
    ax.legend(loc='upper left', fontsize=15)
    plt.show()


def plot_2d(lta_problems):
    impact_votes, likelihood_votes, names = ([] for _ in range(3))

    for _, problem in lta_problems.items():
        names.append(problem.name)
        impact_votes.append(problem.get_impact())
        likelihood_votes.append(problem.get_likelihood())
    s = [500 for _ in range(len(names))]

    plt.scatter(impact_votes, likelihood_votes, s, c="g", alpha=0.5, marker=r'D', label=LABELS)
    plt.scatter(1, 1, marker='X', color='gold', s=500)
    for i, problem in enumerate(names):
        plt.text(impact_votes[i], likelihood_votes[i], problem, fontsize=15)
    plt.text(1, 1, 'optimum', fontsize=15)

    plt.xlabel('impact (1: high, 2: medium, 3: low)', fontsize=15)
    plt.ylabel('likelihood (1: very likely, 2: occurs, 3: highly unlikely)', fontsize=15)
    plt.legend(loc='upper right', fontsize=15)
    plt.show()


def generate_accumulated_results(directory, dimensions):
    path_list = Path(directory).rglob('*.csv')
    lta_problems = {}
    for path in path_list:
        file = str(path)
        print("#######################################\nprocessing", file)
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
    if dimensions == "2":
        plot_2d(lta_problems)
    elif dimensions == "3":
        plot_3d(lta_problems)
    else:
        print("unsupported number of dimensions: %s", dimensions)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='analyze results of questionnaire')
    parser.add_argument('-i', '--input', help='input file', required=True)
    parser.add_argument('-d', '--dimensions', help='number of dimensions to plot', required=True)
    args = vars(parser.parse_args())
    generate_accumulated_results(args['input'], args['dimensions'])
