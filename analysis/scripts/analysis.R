library(ggplot2)

######################################################################
################################ PLOTS ###############################
######################################################################

gen_plot <- function(plotPointsPre, y_name, x_name, filename) {
    finalPlot <- plotPointsPre + geom_bar(stat="identity", fill = c(rgb(32, 43, 50, maxColorValue = 255)), width=0.75) + coord_flip() + xlab(x_name) + ylab(y_name) + scale_color_manual(values=c("#d44345", "#0bc986"))
    ggsave(finalPlot, file = filename, width=6, height=4)
}

input <- read.csv(file = "../experiments/monitoring_eval/final_res.csv", header = TRUE, sep = ",")

gen_plot(ggplot(data = input, aes(x = experiment, y = duration, color = completed, group = completed)), "duration (h)", "experiment", "duration.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = correct_contingencies, color = completed, group = completed)), "correct_contingencies", "experiment", "corr_cont.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = false_positives, color = completed, group = completed)), "false positive contingencies", "experiment", "false_positives.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = false_negatives, color = completed, group = completed)), "false negative contingencies", "experiment", "false_negatives.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = correct_no_contingency, color = completed, group = completed)), "correct NO contingencies", "experiment", "correct_no_contingencies.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = unexpected_contingencies, color = completed, group = completed)), "unexpected contingencies", "experiment", "unexpected_contingencies.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = completed_tasks, color = completed, group = completed)), "completed tasks", "experiment", "completed_tasks.png")
gen_plot(ggplot(data = input, aes(x = experiment, y = charge_cycles, color = completed, group = completed)), "charge cycles", "experiment", "charge_cycles.png")
gen_plot(ggplot(data = input, aes(
        x = experiment, color = completed, group = completed,
        y = (correct_contingencies + correct_no_contingency) / (correct_contingencies + correct_no_contingency + false_positives + false_negatives + unexpected_contingencies) * 100
    )
), "expected response to fail sim (%)", "experiment", "expected_res.png")

gen_plot(ggplot(data = input, aes(
        x = experiment, color = completed, group = completed,
        y = (traverse_time + scan_time + charge_time + dock_time + undock_time) / (traverse_time + scan_time + charge_time + dock_time + undock_time + wait_time + cata_time + cont_time) * 100
    )
), "autonomy (%)", "experiment", "autonomy_percentage.png")

gen_plot(ggplot(data = input, aes(
        x = experiment, color = completed, group = completed,
        y = (cata_time + cont_time) / (traverse_time + scan_time + charge_time + dock_time + undock_time + wait_time + cata_time + cont_time) * 100
    )
), "recovery time (%)", "experiment", "recovery_percentage.png")

######################################################################
############################## ANALYSIS ##############################
######################################################################

compute_avg_duration <- function() {
    costs <- subset(input, select = c(duration), completed == "True")
    return(round(mean(as.numeric(as.character(costs[["duration"]]))), digits = 2))
}

compute_avg_completed_tasks <- function() {
    costs <- subset(input, select = c(completed_tasks), completed == "True")
    return(round(mean(as.numeric(as.character(costs[["completed_tasks"]]))), digits = 2))
}

compute_avg_charge_cycles <- function() {
    costs <- subset(input, select = c(charge_cycles), completed == "True")
    return(round(mean(as.numeric(as.character(costs[["charge_cycles"]]))), digits = 2))
}

compute_avg_mission_cycles <- function() {
    costs <- subset(input, select = c(mission_cycles), completed == "True")
    return(round(mean(as.numeric(as.character(costs[["mission_cycles"]]))), digits = 2))
}

compute_avg_total_dist <- function() {
    costs <- subset(input, select = c(total_dist), completed == "True")
    return(round(mean(as.numeric(as.character(costs[["total_dist"]]))), digits = 2))
}

compute_avg_percentage_expected_response <- function() {
    costs <- subset(input, select = c(correct_contingencies, correct_no_contingency, false_negatives, false_positives, unexpected_contingencies))
    return(round(mean(as.numeric(as.character((
        (costs[["correct_contingencies"]] + costs[["correct_no_contingency"]]) /
        (costs[["correct_contingencies"]] + costs[["correct_no_contingency"]] + costs[["false_negatives"]] + costs[["false_positives"]] + costs[["unexpected_contingencies"]])
    ) * 100))), digits = 2))
}

paste("avg duration: ", compute_avg_duration(), "h")
paste("avg #completed_tasks: ", compute_avg_completed_tasks())
paste("avg #charge_cycles: ", compute_avg_charge_cycles())
paste("avg #mission_cycles: ", compute_avg_mission_cycles())
paste("avg total distance: ", compute_avg_total_dist(), "m")
paste("avg expected response to fail sim: ", compute_avg_percentage_expected_response(), "%")
