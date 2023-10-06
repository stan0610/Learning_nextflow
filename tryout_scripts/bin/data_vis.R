#!/usr/bin/env Rscript

################################################################################
# script to visualize data to integrate into nextflow
################################################################################

# setup
# x <-paste("C:/Users/Stan/OneDrive - Hogeschool West-Vlaanderen/SCHOOL/",
#           "BIT 01 Linux OS/SF/singlecell_Stan/learning_nextflow/",
#           "tryout_scripts/bin/", sep="")
#setwd(x)
#install.packages("dplyr")
library(dplyr)
#install.packages("knitr")
library(knitr)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("htmlTable")
library(htmlTable)

# command line via nextflow
args = commandArgs(trailingOnly = TRUE)

# read in data
pigs <- read.csv(args[1], sep = ",", header = TRUE)

# table ==> html files get weird when nextflow is involved, skip for now
#table <- kable(pigs)
#htmlTable(table, file = "/home/guest/nextflow/output/output/table.html")

################################################################################
boxplot

 # pigs in long format
pigs_long <- pigs %>%
  pivot_longer(cols = starts_with("Diet"),
               names_to = "Diet",
               values_to = "Weight")

 # actual plot
custom_colors <- c("#4472C4", "#70AD47", "#FFC000", "#7030A0")

boxp <- ggplot(data = pigs_long, aes(x = Diet,
                                     y = Weight,
                                     fill=Diet)) +
  geom_boxplot() +
  labs(x = "Diet",
       y = "Weight") +
  ggtitle("Weight Distribution by Diet") +
  scale_fill_manual(values = custom_colors) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

boxp

 # save the plot
ggsave("/home/guest/nextflow/output/boxplot.pdf", boxp, width = 8, height = 6)



################################################################################
barplot

 # group by diet and take average weight
grouped_pigs <- pigs_long %>%
  group_by(Diet) %>%
  summarize(AverageWeight = mean(Weight))

 # barplot
barpl <- ggplot(data = grouped_pigs, aes(x = AverageWeight,
                                         y = Diet,
                                         fill = Diet)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = custom_colors) +
  labs(x = "Average Weight",
       y = "Diet") +
  ggtitle("Average Weight by Diet") +
  theme(plot.title = element_text(hjust = 0.5))

barpl
  # save barplot
ggsave("/home/guest/nextflow/output/barplot.pdf", barpl, width = 8, height = 6)





