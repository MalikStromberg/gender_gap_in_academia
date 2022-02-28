library(tidyverse)
library(ggplot2)

data_author <- readRDS('data/_final/data_author_labeled.rds')

pub_date <- data.frame(
  pub_date = apply(select(data_author, pub.print.year, pub.online.year),
                   1,
                   min))

p1 <- ggplot(data = pub_date) +
  geom_histogram(aes(x = pub_date), fill = '#00703C', binwidth = 5) +
  labs(title = 'Number of Publications per Year',
       x = 'Year',
       y = 'Count') +
  theme_bw(base_size = 16) +
  theme(plot.title = element_text(hjust=0.5),
        axis.text = element_text(size = 14))
p1

ggsave('figures/number_pubs_per_year.png', p1)

label <- data_author %>% group_by(label_6) %>% summarize(count = n())
label$percent <- label$count/sum(label$count)

p2 <- ggplot(data = label, aes(x = reorder(label_6, -percent), y = percent)) +
  geom_bar(stat = 'identity', fill = '#00703C') +
  labs(title = 'Relative Frequency per Gender - Prediction with Name Endings',
       x = 'Gender',
       y = 'Relative Frequency') +
  theme_bw(base_size = 16) +
  theme(plot.title = element_text(hjust=0.5),
        axis.text = element_text(size = 14)) +
  scale_x_discrete(labels=c("M" = "Male", "F" = "Female",
                            "D" = "Unisex", "U" = "Unknown"))
p2
ggsave('figures/relative_frequency_per_gender_endings.png', p2)

label <- data_author %>% group_by(label_full_name_6) %>% summarize(count = n())
label$percent <- label$count/sum(label$count)
label$label_full_name <- factor(label$label_full_name_6,
                                levels=c("M", "F", "U", "D"))

p3 <- ggplot(data = label,
             aes(x = label_full_name_6, y = percent)) +
  geom_bar(stat = 'identity', fill = '#00703C') +
  labs(title = 'Relative Frequency per Gender - Prediction Only by Full Name',
       x = 'Gender',
       y = 'Relative Frequency') +
  theme_bw(base_size = 16) +
  theme(plot.title = element_text(hjust=0.5),
        axis.text = element_text(size = 14)) +
  scale_x_discrete(labels=c("M" = "Male", "F" = "Female",
                            "D" = "Unisex", "U" = "Unknown"))
p3
ggsave('figures/relative_frequency_per_gender_full_name.png', p3)

