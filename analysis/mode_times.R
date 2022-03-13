library(ggplot2)

gen_plot <- function(plotPointsPre, y_name, x_name, filename) {
    finalPlot <- plotPointsPre + coord_flip() + xlab(x_name) + ylab(y_name)
    ggsave(finalPlot, file = filename, width=6, height=4)
}

input <- read.csv(file = "modes.csv", header = TRUE, sep = ",")

ggp <- ggplot(input, aes(x = experiment, y = mode_time, fill = mode)) + geom_bar(position = "stack", stat = "identity") + scale_fill_manual("mode", values = c("cata" = "#003f5c", "charge" = "#2f4b7c", "cont" = "#665191", "dock" = "#a05195", "scan" = "#d45087", "traverse" = "#f95d6a", "undock" = "#ff7c43", "wait" = "#ffa600"))

gen_plot(ggp, "mode times (s)", "experiment", "mode_times.png")
