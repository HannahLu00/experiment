library(plyr)
library(dplyr)
library(MPDiR)
library(quickpsy)
library(fitdistrplus)
library(ggplot2)
library(ggpubr)
library(patchwork)
library(RColorBrewer)
library(tidyverse)
library(HH)
library(likert)


# set directory where script is
sourceDir <- dirname (rstudioapi::getActiveDocumentContext()$path) 
defaultpath <- sourceDir

# print(defaultpath)
setwd(defaultpath)

# read global values
source("1-read-and-bind-all-files.R")

# read file content, with header
df <- read.csv("results/sort_data.csv", header = TRUE, encoding="UTF-8")

setwd(defaultpath)

# remove the first column label
for (i in 1:ncol(df)){
  df[,i] <- factor(df[,i], levels = interest_level)
}

print(is.data.frame(df))
df <- as.data.frame(df[-c(1)], row.names = NULL)

# let 'don't know' column at left part
p <- plot(likert(df), center = 1.5)

# let 'don't know + not interested' columns at left part
p2 <- plot(likert(df), center = 2.5)

ggsave("stacked bars in percentage - keep dont know.pdf", plot = p, device = "pdf", path = "plots", width = 10, height = 5, dpi = 300)
ggsave("stacked bars in percentage - keep dont know + not interested.pdf", plot = p2, device = "pdf", path = "plots", width = 10, height = 5, dpi = 300)


  


