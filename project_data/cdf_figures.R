library(tidyverse)
library(ggplot2)

data <- readRDS('data/_final/data_author_labeled.rds')

accuracy <- data %>% select(accuracy)

p1 <-ggplot(data = accuracy,aes(x = accuracy)) +
  stat_ecdf(size = 1.5) +
  theme_bw(base_size = 16) +
  xlab(label = 'P (gender | name)') +
  xlim(.5, 1) +
  ylab(label = 'CDF') +
  ggtitle('Cumulative Distribution Function of Accuracy') +
  theme(plot.title = element_text(hjust = 0.5))
p1

ggsave('figures/cdf_accuracy_full.png', p1, width = 8, height = 5, units = 'in')


# accuracy <- accuracy %>% filter(accuracy <= 0.95 & accuracy >= .5)

p1 <- ggplot(data = accuracy,aes(x = accuracy)) +
  stat_ecdf(size = 1.5) +
  theme_bw(base_size = 16) +
  xlab(label = 'P (gender | name)') +
  xlim(.5, .95) +
  ylab(label = 'CDF') +
  ggtitle('Cumulative Distribution Function of Accuracy') +
  theme(plot.title = element_text(hjust = 0.5))
p1

ggsave('figures/cdf_accuracy.png', p1, width = 8, height = 5, units = 'in')
