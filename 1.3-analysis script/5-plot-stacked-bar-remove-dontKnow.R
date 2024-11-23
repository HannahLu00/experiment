library(plyr)
library(dplyr)
library(MPDiR)
library(quickpsy)
library(fitdistrplus)
library(ggplot2)
library(ggpubr)
library(patchwork)
library(RColorBrewer)


# set directory where script is
sourceDir <- dirname (rstudioapi::getActiveDocumentContext()$path) 
defaultpath <- sourceDir

# print(defaultpath)
setwd(defaultpath)

# read global values
source("1-read-and-bind-all-files.R")

# read file content, with header
df <- read.csv("results/3_count/count_median_mode_remove_dontKnow.csv", header = TRUE, encoding="UTF-8")

setwd(defaultpath)

# create data
# try to to append the values according to interest level: from not interest at all to extremely interest
interest_values <- integer()
for (i in 4:8){
  interest_values <- append(interest_values, df[, i])
}

# create the interest level names
interest_level_names <- colnames(df[4:8])

# create the data descriptions
data_description <- character()
for(i in 1:nrow(df)){
  data_description <- append(data_description, df[i, 3])
}

# # try to make the mode(s) be plotted in different color
# # @v = colnames(df)[4:8]
# # @m = df[1, 11:ncol(df)]
# color <- function(v, m){
#   tmp <- c()
#   for(i in 1:length(v)){
#     for(j in 1:length(m)){
#       # if the mode value is equal to NA
#       if (is.na(m[j])){
#         tmp <- append(tmp, general_color)
#         break
#         # if the count of this interest level is equal to any mode 
#       }else{
#         if (v[i] == m[j]){
#           # highlight its color
#           tmp <- append(tmp, mode_color)
#           break
#         }else{
#           # make sure the current mode is the last mode, if yes
#           if ( j == length(m)){
#             tmp <- append(tmp, general_color)
#             break
#           }else{
#             if (is.na(m[j+1])){
#               tmp <- append(tmp, general_color)
#               break
#               # if no, do nothing and continue
#             }else{
#               next
#             }
#           }
#           
#         }
#       }
#     }
#   }
#   return (tmp)
# }

stacked_bar_data <- data.frame(
  col_names = rep(interest_level_names, each = nrow(df)),
  row_names = rep(data_description, 5),
  values = interest_values
  # color_palette = 
)

# head(stacked_bar_data)

# color <- brewer.pal(n = 5, name = "Purples")

# plot in percentage
p1 <- ggplot(stacked_bar_data, aes(x = factor(row_names, levels = rev(data_description)), y = values)) +
      geom_col(aes(fill = factor(col_names, levels = interest_level_names)), width = 1, position = position_fill(TRUE)) +
      scale_fill_brewer(palette = "Blues") +
      scale_y_continuous(
                            breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1.0), 
                            labels = c("0%", "20%", "40%", "60%", "80%", "100%")
                            ) +
      labs(x = "Data description", y = "Percentage") +
      guides(fill = guide_legend(title = "Interest level")) + 
      coord_flip()

print(p1)

# plot in real value 
p2 <- ggplot(stacked_bar_data, aes(x = factor(row_names, levels = rev(data_description)), y = values, fill = factor(col_names, levels = interest_level_names))) +
     # geom_col(aes(fill = factor(col_names, levels = interest_level_names)), width = 0.7, position = position_fill(TRUE)) +
     geom_bar(stat = "identity", width = 1) +
     scale_fill_brewer(palette = "Blues") +
     scale_y_continuous(
                        breaks = c(0, 2, 4, 6, 8, 10)
                        ) +
     labs(x = "Data description", y = "Participants' counts") +
     guides(fill = guide_legend(title = "Interest level")) + 
     coord_flip()
     

print(p2)

ggsave("stacked bars in percentage - remove dont know.pdf", plot = p1, device = "pdf", path = "plots", width = 10, height = 5, dpi = 300)
ggsave("stacked bars in real value - remove dont know.pdf", plot = p2, device = "pdf", path = "plots", width = 10, height = 5, dpi = 300)


