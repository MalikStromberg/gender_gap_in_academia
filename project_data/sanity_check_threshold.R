source('functions/f_get_fields.R')
source('functions/f_gender_per_field.R')

library(tidyverse)

# load data sets
names <- readRDS('data/name/tidy_name_data/names_db.rds')
names_ending <- readRDS('data/name/tidy_name_data/names_ending.Rds')
authors <- readRDS('data/author/tidy_author_data/data_author.rds') %>%
  select(gname, published.print, published.online, any_of(get_fields(T)))
unknowns <- readRDS('data/name/tidy_name_data/names_api.rds')
thresholds <- seq(.5, .9, .05)

# initializing
ratios <- data.frame()

for (i in thresholds) {
  # create data set for specific threshold
  dat <- gender_per_field(data = authors,
                          names = names,
                          endings = names_ending,
                          unknowns = unknowns,
                          threshold = i)
  # order to assure correct naming
  dat <- dat[order(as.character(dat$field)), ]
  ratios <- rbind(ratios, dat$f_m_ratio)

}

# naming
colnames(ratios) <- get_fields(T)[order(get_fields(T))]

# prepare for plot
ratios <- reshape2::melt(ratios)
ratios$threshold <- rep(thresholds, length(get_fields()))
colnames(ratios) <- c('field', 'f_m_ratio', 'threshold')
plot_data <- ratios %>% filter(field != 'gender_studies')

# detect groups in fields by f_m_ratio
ordered_fields <- plot_data %>%
  select(field, f_m_ratio) %>%
  group_by(field) %>%
  summarize_all(mean)

ordered_fields <- ordered_fields[order(ordered_fields$f_m_ratio), ]

# split data into groups for different plots
plot_data1 <- plot_data %>%
  filter(field %in% ordered_fields$field[1:6])
  
plot_data2 <- plot_data %>%
  filter(field %in% ordered_fields$field[7:13])
plot_data3 <- plot_data %>%
  filter(field %in% ordered_fields$field[14:19])

# create dictionary for fields
dictionary <- get_fields(F) %>%
  str_replace_all('and', '&') %>%
  str_replace_all('Human Resource', 'HR') %>%
  str_replace_all('miscellaneous', 'misc.')
names(dictionary) <- get_fields(T)

# create plots
p1 <- ggplot(data = plot_data1, aes(x = threshold,
                                    y = f_m_ratio,
                                    color = field)) +
  geom_line(aes(group = field)) +
  theme_bw(base_size = 16) +
  xlab(label = 'Threshold') +
  ylab(label = 'f / m ratio') +
  ggtitle('Female-Male Ratio at Different Thresholds') +
  scale_color_discrete(labels = dictionary) +
  guides(color = guide_legend(nrow = 3)) +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5))
  
p2 <- ggplot(data = plot_data2, aes(x = threshold,
                                    y = f_m_ratio,
                                    color = field)) +
  geom_line(aes(group = field)) +
  theme_bw(base_size = 16) +
  xlab(label = 'Threshold') +
  ylab(label = 'f / m ratio') +
  ggtitle('Female-Male Ratio at Different Thresholds') +
  scale_color_discrete(labels = dictionary) +
  guides(color = guide_legend(nrow = 3)) +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5))
p3 <- ggplot(data = plot_data3, aes(x = threshold,
                                    y = f_m_ratio,
                                    color = field)) +
  geom_line(aes(group = field)) +
  theme_bw(base_size = 16) +
  xlab(label = 'Threshold') +
  ylab(label = 'f / m ratio') +
  ggtitle('Female-Male Ratio at Different Thresholds') +
  scale_color_discrete(labels = dictionary) +
  guides(color = guide_legend(nrow = 3)) +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5))

# save figures
ggsave('figures/ratio_per_threshold1.png',
       p1,
       width = 9,
       height = 5.5,
       units = 'in')
ggsave('figures/ratio_per_threshold2.png',
       p2,
       width = 9,
       height = 5.5,
       units = 'in')
ggsave('figures/ratio_per_threshold3.png',
       p3,
       width = 9,
       height = 5.5,
       units = 'in')
