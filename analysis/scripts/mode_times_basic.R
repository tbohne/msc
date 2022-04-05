library(ggplot2)

gen_plot <- function(plot_points_pre, y_name, x_name, filename) {
    final_plot <- plot_points_pre + coord_flip() + xlab(x_name) + ylab(y_name)
    ggsave(final_plot, file = filename, width = 6, height = 4)
}
input <- read.csv(file = "../experiments/prototype_eval/mode_times.csv", header = TRUE, sep = ",")
ggp <- ggplot(input, aes(x = experiment, y = mode_time, fill = mode)) + geom_bar(position = "stack", stat = "identity") + scale_fill_manual(
    "mode", values = c("charge" = "#2f4b7c", "dock" = "#a05195", "scan" = "#d45087", "traverse" = "#f95d6a", "undock" = "#ff7c43", "wait" = "#ffa600")
)
gen_plot(ggp, "mode times (s)", "experiment", "mode_times_basic.png")
