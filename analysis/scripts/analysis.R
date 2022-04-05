library(ggplot2)

####################################################################################################
########################################### PLOTS ##################################################
####################################################################################################

gen_plot <- function(plot_points_pre, y_name, x_name, filename) {
    final_plot <- plot_points_pre + geom_bar(stat = "identity", fill = c(rgb(32, 43, 50, maxColorValue = 255)),
        width = 0.75) + coord_flip() + xlab(x_name) + ylab(y_name) + scale_color_manual(values = c("#d44345", "#0bc986"))
    ggsave(final_plot, file = filename, width = 6, height = 4)
}

# monitoring framework evaluation
input <- read.csv(file = "../experiments/monitoring_eval/final_res.csv", header = TRUE, sep = ",")

# prototype scenario evaluation
# input <- read.csv(file = "../experiments/prototype_eval/final_res.csv", header = TRUE, sep = ",")

# basic plots
gen_plot(ggplot(data = input, aes(x = experiment, y = duration, color = completed, group = completed)), "duration (h)", "experiment", "duration.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = correct_contingencies, color = completed, group = completed)), "correct_contingencies", "experiment", "corr_cont.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = false_positives, color = completed, group = completed)), "false positive contingencies", "experiment", "false_positives.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = false_negatives, color = completed, group = completed)), "false negative contingencies", "experiment", "false_negatives.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = correct_no_contingency, color = completed, group = completed)), "correct NO contingencies", "experiment", "correct_no_contingencies.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = unexpected_contingencies, color = completed, group = completed)), "unexpected contingencies", "experiment", "unexpected_contingencies.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = completed_tasks, color = completed, group = completed)), "completed tasks", "experiment", "completed_tasks.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = charge_cycles, color = completed, group = completed)), "charge cycles", "experiment", "charge_cycles.png")

# analysis plots
gen_plot(ggplot(data = input, aes(
        x = experiment, color = completed, group = completed,
        y = (correct_contingencies + correct_no_contingency) / (correct_contingencies + correct_no_contingency + false_positives + false_negatives + unexpected_contingencies) * 100
    )
), "expected response to fail sim (%)", "experiment", "expected_res.png")

gen_plot(ggplot(data = input, aes(
        x = experiment, color = completed, group = completed,
        y = (traverse_time + scan_time + cont_time + dock_time + undock_time) / (traverse_time + scan_time + charge_time + dock_time + undock_time + wait_time + cata_time + cont_time) * 100
    )
), "autonomy (%)", "experiment", "autonomy_percentage.png")

gen_plot(ggplot(data = input, aes(
        x = experiment, color = completed, group = completed,
        y = (cata_time + cont_time) / (traverse_time + scan_time + charge_time + dock_time + undock_time + wait_time + cata_time + cont_time) * 100
    )
), "recovery time (%)", "experiment", "recovery_percentage.png")

####################################################################################################
########################################## ANALYSIS ################################################
####################################################################################################

compute_avg_basic <- function(values, category) {
    return(round(mean(as.numeric(as.character(values[[category]]))), digits = 2))
}

compute_avg_percentage_expected_response <- function() {
    vals <- subset(input, select = c(correct_contingencies, correct_no_contingency, false_negatives, false_positives, unexpected_contingencies))
    return(round(mean(as.numeric(as.character((
        (vals[["correct_contingencies"]] + vals[["correct_no_contingency"]]) /
        (vals[["correct_contingencies"]] + vals[["correct_no_contingency"]] + vals[["false_negatives"]] + vals[["false_positives"]] + vals[["unexpected_contingencies"]])
    ) * 100))), digits = 2))
}

compute_avg_autonomy_percentage <- function() {
    vals <- subset(input, select = c(traverse_time, scan_time, cont_time, dock_time, undock_time, charge_time, wait_time, cata_time))
    return(round(mean(as.numeric(as.character((
        (vals[["traverse_time"]] + vals[["scan_time"]] + vals[["cont_time"]] + vals[["dock_time"]] + vals[["undock_time"]]) /
        (vals[["traverse_time"]] + vals[["scan_time"]] + vals[["charge_time"]] + vals[["dock_time"]] + vals[["undock_time"]] + vals[["wait_time"]] + vals[["cata_time"]] + vals[["cont_time"]])
    ) * 100))), digits = 2))
}

durations <- subset(input, select = c(duration), completed == "True")
task_nums <- subset(input, select = c(completed_tasks), completed == "True")
charge_cycle_cnts <- subset(input, select = c(charge_cycles), completed == "True")
mission_cycle_cnts <- subset(input, select = c(mission_cycles), completed == "True")
dists <- subset(input, select = c(total_dist), completed == "True")
sim_problem_cnts <- subset(input, select = c(simulated_problems), completed == "True")

paste("avg duration: ", compute_avg_basic(durations, "duration"), "h")
paste("avg #completed_tasks: ", compute_avg_basic(task_nums, "completed_tasks"))
paste("avg #charge_cycles: ", compute_avg_basic(charge_cycle_cnts, "charge_cycles"))
paste("avg #mission_cycles: ", compute_avg_basic(mission_cycle_cnts, "mission_cycles"))
paste("avg total distance: ", compute_avg_basic(dists, "total_dist"), "m")
paste("avg expected response to fail sim: ", compute_avg_percentage_expected_response(), "%")
paste("avg #simulated_problems: ", compute_avg_basic(sim_problem_cnts, "simulated_problems"))
paste("avg autonomy_percentage: ", compute_avg_autonomy_percentage())
