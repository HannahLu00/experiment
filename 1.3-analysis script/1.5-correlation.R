library(plyr)
library(dplyr)
library(MPDiR)
library(quickpsy)
library(fitdistrplus)
library(ggplot2)
library(tibble)
library(corrplot)

# set directory where script is
sourceDir <- dirname (rstudioapi::getActiveDocumentContext()$path) 
defaultpath <- sourceDir

print(defaultpath)
setwd(defaultpath)

# read global values
source("1-read-and-bind-all-files.R")

filename <- "results/replaced.csv"
dataFile <- read.csv(filename)

#sort all data
sort_table <- dataFile[, c(swimmer_colnames, time_colnames, speed_colnames, distance_colnames, record_colnames, swimming_teachniques_colnames, predictions_colnames, external_data_colnames, "watching_frequency_grade")]
write.csv(sort_table, file= "results/replaced_sort_data.csv")

df_pearson <- sort_table
df_spearman <- sort_table

# pearson
corr_all_pearson <- round(cor(df_pearson,method = "pearson"), digits = 2)
write.csv(corr_all_pearson, file= "results/correlation_all_pearson.csv")
print(corr_all_pearson)

# spearman
corr_all_spearman <- round(cor(df_spearman,method = "spearman"), digits = 2)
write.csv(corr_all_spearman, file= "results/correlation_all_spearman.csv")
print(corr_all_spearman)

# res <- cor.test(sort_table$watching_frequency_grade, sort_table$elapsed_time_interest, method = "kendall")
# print(res)

# pearson
pdf(file = "plots/correlation_heatmap_pearson.pdf")
corrplot(cor(df_pearson,method = "pearson"), method = "number", type = "upper", title = "Correlation heatmap between watching frequency and data items (Pearson)", mar = c(0, 0, 1, 0), number.cex = 0.3, tl.cex = 0.3, cl.cex = 0.5, number.digits = 2)
dev.off()

# spearman
pdf(file = "plots/correlation_heatmap_spearman.pdf")
corrplot(cor(df_spearman,method = "spearman"), method = "number", type = "upper", title = "Correlation heatmap between watching frequency and data items (Spearman)", mar = c(0, 0, 1, 0), number.cex = 0.3, tl.cex = 0.3, cl.cex = 0.5, number.digits = 2)
dev.off()
 
# p2 <- plot(sort_table$watching_frequency_grade, sort_table$elapsed_time_interest)
# ggsave("elapsed_time_scatter_plot.pdf", plot = p2, device = "pdf", path = "plots", width = 5, height = 20, dpi = 300)




