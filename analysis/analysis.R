library(ggplot2)

gen_plot <- function(plotPointsPre, x_name, y_name, filename) {
    finalPlot <- plotPointsPre + geom_point() + xlab(x_name) + ylab(y_name) + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
    ggsave(finalPlot, file = filename, width=6, height=4)
}

input <- read.csv(file = "placeholder.csv", header = TRUE, sep = ",")

gen_plot(ggplot(data = input, aes(x = duration, y = experiment, color = completed, group = completed)), "duration (h)", "experiment", "duration.png")
gen_plot(ggplot(data = input, aes(x = correct_contingencies, y = experiment, color = completed, group = completed)), "correct_contingencies", "experiment", "corr_cont.png")
gen_plot(ggplot(data = input, aes(x = false_positives, y = experiment, color = completed, group = completed)), "false positive contingencies", "experiment", "false_positives.png")
gen_plot(ggplot(data = input, aes(x = false_negatives, y = experiment, color = completed, group = completed)), "false negative contingencies", "experiment", "false_negatives.png")
gen_plot(ggplot(data = input, aes(x = correct_no_contingency, y = experiment, color = completed, group = completed)), "correct NO contingencies", "experiment", "correct_no_contingencies.png")
gen_plot(ggplot(data = input, aes(x = unexpected_contingencies, y = experiment, color = completed, group = completed)), "unexpected contingencies", "experiment", "unexpected_contingencies.png")
gen_plot(ggplot(data = input, aes(x = completed_tasks, y = experiment, color = completed, group = completed)), "completed tasks", "experiment", "completed_tasks.png")
gen_plot(ggplot(data = input, aes(x = charge_cycles, y = experiment, color = completed, group = completed)), "charge cycles", "experiment", "charge_cycles.png")
gen_plot(ggplot(data = input, aes(x = (correct_contingencies + correct_no_contingency) / (correct_contingencies + correct_no_contingency + false_positives + false_negatives + unexpected_contingencies) * 100, y = experiment, color = completed, group = completed)), "expected response to fail sim (%)", "experiment", "expected_res.png")

compute_avg_duration <- function() {
    costs <- subset(input, select = c(duration))
    return(round(mean(as.numeric(as.character(costs[["duration"]]))), digits = 2))
}

paste("avg duration: ", compute_avg_duration())
