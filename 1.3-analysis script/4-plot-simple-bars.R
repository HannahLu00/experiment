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
# print(dataFile)

setwd(defaultpath)

# find the max value in database
dfMax <- function(dataframe){
            tmp <- integer()
            for(i in 4:8){
              tmp <- append(tmp, max(dataframe[,i]))
            } 
            return (max(tmp))
          }

# set the y threshold of plot as the max value of database
y_threshold <- dfMax(df)
# print(y_threshold)

# define the general color and the mode color
general_color <- "#8DA0CB"
mode_color <- "#A6D854"
mean_color <- "#FC8D62"

# try to make the mode(s) be plotted in different color
# @v = colnames(df)[4:8]
# @m = df[1, 11:ncol(df)]
color <- function(v, m){
          tmp <- c()
          for(i in 1:length(v)){
            for(j in 1:length(m)){
              # if the mode value is equal to NA
              if (is.na(m[j])){
                tmp <- append(tmp, general_color)
                break
              # if the count of this interest level is equal to any mode 
              }else{
                if (v[i] == m[j]){
                  # highlight its color
                  tmp <- append(tmp, mode_color)
                  break
                }else{
                  # make sure the current mode is the last mode, if yes
                  if ( j == length(m)){
                    tmp <- append(tmp, general_color)
                    break
                  }else{
                    if (is.na(m[j+1])){
                      tmp <- append(tmp, general_color)
                      break
                      # if no, do nothing and continue
                    }else{
                      next
                    }
                  }
                  
                }
              }
            }
          }
          return (tmp)
        }


# print(color(colnames(df)[4:8], df[1, 11:ncol(df)]))

# create data
bar_data <- data.frame(
  name = colnames(df)[4:8],
  value = as.numeric(df[1,4:8]),
  color_palette = color(colnames(df)[4:8],df[1, 11:ncol(df)])
)

# try to plot multiple bar charts on the same figure

# bar plot
p <- ggplot(data = bar_data, mapping = aes(x = factor(name, levels = colnames(df)[4:8]), y = value)) +
  geom_bar(stat = "identity", width = 0.5, fill = bar_data$color_palette) +
  geom_vline(xintercept = as.numeric(df[1, 10]), color = mean_color, size = 0.3, linetype = "dotted") + 
  labs(x = "interest level", y = df[1, 3])+
  ylim(0, y_threshold) + 
  scale_x_discrete(labels = bar_data$name, position = "top")+
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 4),
        axis.title.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_text(angle = 0, size = 4, hjust = 1, vjust = 0.5),
        plot.margin = margin(t = 0, b = 3)
        )

# graph_one <- p + plot_layout(nrow = nrow(df), ncol = 1, tag_level = "new") + theme(plot.tag = element_text(size = rel(1)))
graph_one <- p

for (i in 2:nrow(df)){
  # create data
  bar_data <- data.frame(
    name = colnames(df)[4:8],
    value = as.numeric(df[i,4:8]),
    color_palette = color(colnames(df)[4:8],df[i, 11:ncol(df)])
  )

  # bar plot
  if ( i == nrow(df)){
    p <- ggplot(data = bar_data, mapping = aes(x = factor(name, levels = colnames(df)[4:8]), y = value)) +
      geom_bar(stat = "identity", width = 0.5, fill = bar_data$color_palette) +
      geom_vline(xintercept = as.numeric(df[i, 10]), color = mean_color, size = 0.3, linetype = "dotted") + 
      labs(x = "interest level", y = df[i, 3])+
      ylim(0, y_threshold) +
      scale_x_discrete(labels = bar_data$name, position = "bottom")+
      theme(axis.ticks.x = element_blank(),
            axis.text.x = element_text(size = 4),
            axis.title.x = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text.y = element_blank(),
            axis.title.y = element_text(angle = 0, size = 4, hjust = 1, vjust = 0.5),
            plot.margin = margin(t = 0, b = 0)
      )

  }else{
    p <- ggplot(data = bar_data, mapping = aes(x = factor(name, levels = colnames(df)[4:8]), y = value)) +
            geom_bar(stat = "identity", width = 0.5, fill = bar_data$color_palette) +
            geom_vline(xintercept = as.numeric(df[i, 10]), color = mean_color, size = 0.3, linetype = "dotted") + 
            labs(x = "interest level", y = df[i, 3])+
            ylim(0, y_threshold) +
            theme(axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.title.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  axis.text.y = element_blank(),
                  axis.title.y = element_text(angle = 0, size = 4, hjust = 1, vjust = 0.5),
                  plot.margin = margin(t = 0, b = 0)
                  )
  }

  graph_one <- graph_one + p + plot_layout(nrow = nrow(df), ncol = 1, tag_level = "new") + theme(plot.tag = element_text(size = rel(1)))

}

print(graph_one)

ggsave("bar charts with median and modes.pdf", plot = graph_one, device = "pdf", path = "plots", width = 5, height = 20, dpi = 300)





