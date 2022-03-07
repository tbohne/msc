library(ggplot2)

input <- read.csv(file = "placeholder.csv", header = TRUE, sep = ",")

plotPointsPre <- ggplot(data = input, aes(x = duration, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("duration (h)") + ylab("experiment")  + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "duration.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = correct_contingencies, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("correct_contingencies") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "corr_cont.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = false_positives, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("false positive contingencies") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "false_positives.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = false_negatives, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("false negative contingencies") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "false_negatives.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = correct_no_contingency, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("correct NO contingencies") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "correct_no_contingencies.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = unexpected_contingencies, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("unexpected contingencies") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "unexpected_contingencies.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = completed_tasks, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("completed tasks") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "completed_tasks.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = charge_cycles, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("charge cycles") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "charge_cycles.png", width=6, height=4)

plotPointsPre <- ggplot(data = input, aes(x = (correct_contingencies + correct_no_contingency) / (correct_contingencies + correct_no_contingency + false_positives + false_negatives + unexpected_contingencies) * 100, y = experiment, color = completed, group = completed))
finalPlot <- plotPointsPre + geom_point() + xlab("expected response to fail sim (%)") + ylab("experiment") + scale_color_manual(values=c("#fa9f27", "#5428ff", "#f5503b", "#28bd5a"))
ggsave(finalPlot, file = "expected_res.png", width=6, height=4)

compute_avg_duration <- function() {
    costs <- subset(input, select = c(duration))
    return(round(mean(as.numeric(as.character(costs[["duration"]]))), digits = 2))
}

paste("avg duration: ", compute_avg_duration())
