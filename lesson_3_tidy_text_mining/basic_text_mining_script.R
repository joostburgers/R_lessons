library(dplyr)
library(tidytext)
library(janeaustenr)
library(stringr)
library(ggplot2)
library(gutenbergr)
library(tidyr)
library(scales)
library(ggthemes)
library(magrittr)
#library(devtools)




text <- c("Because I could not stop for Death -",
          "He because stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
text["because", "he kindly", "the Carriage"]
text

#What is the c() function here and how does it work?

text_df <- data_frame(line = 1:4, text = text)
text_df  

#What is the difference between text and text_df? Why does it matter?


text_df %>%
  unnest_tokens(word, text)  

#What is the parameter 
#"word" doing in the function? 

austen_temp <- austen_books()
 
original_books <- austen_books() %>% #'and then'
  group_by(book) %>% 
  mutate(linenumber = row_number(), chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()
original_books



#What is this code doing? Line by line.
#Let's look at the original file first. 
austen <-  austen_books()



tidy_books <- original_books %>%
  unnest_tokens(word, text)  

df_stopwords <-  data(stop_words)

paritosh_words <- data_frame(word = c("jane", "emma", "john"))

tidy_books <- tidy_books %>%
  anti_join(stop_words)  

tidy_books <- tidy_books %>% 
  anti_join(paritosh_words)
  
capital_stopwords <- as.data.frame(str_to_title(stop_words$word)) %>% 
                        rename(word= 1)

tidy_books %>%
  count(word, sort= TRUE)  

#What is the anti_join function doing?


  tidy_books %>%
    count(word, sort = TRUE) %>%
    filter(n > 700) %>%
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n)) +
    geom_col() +
    xlab(NULL) +
    coord_flip()
#Let's say I wanted to see only those words that had a frequency over 700 how
#would I change this?
  
  

#sprucing up sad graphics  
tidy_books %>%
  count(word, sort = TRUE) %>%
    top_n(10) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  labs(title = "Top Ten Frequent Words in Jane Austen", 
       caption = "This plot was made with the Tidyverse austen_books data set",
       x = "Top Ten Words",
       y = "Frequency")+
  theme_fivethirtyeight()+
  coord_flip()

#What are the extra lines of code and what might they be doing? How might we be
#able to change the theme? How can we expand or reduce the number of results?



hgwells <- gutenberg_download(c(35, 36, 5230, 159))

hgwells <- gutenberg_download(c(35, 36, 5230, 159), mirror = "ftp://ftp.ibiblio.org/pub/docs/books/gutenberg/")

tidy_hgwells <- hgwells %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_hgwells %>%
  count(word, sort = TRUE)    



bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767), mirror = "http://mirrors.xmission.com/gutenberg/")
tidy_bronte <- bronte %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)  

tidy_bronte %>%
  count(word, sort = TRUE)  


frequency3 <- bind_rows(mutate(tidy_bronte, author = "Brontë Sisters"),
                       mutate(tidy_hgwells, author = "H.G. Wells"),
                       mutate(tidy_books, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = author, values_from = proportion) %>%
  pivot_longer(`Brontë Sisters`:`H.G. Wells`,
               names_to = "author", values_to = "proportion")

# expect a warning about rows with missing values being removed
ggplot(frequency3, aes(x = proportion, y = `Jane Austen`, 
                      color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)

#There's a lot of complicated stuff going on here. How can we reverse engineer
#this? 



#There's a better way! We have to update Rstudio a bit. Rstudio has the
#option of including custom add-ins by anyone on the internet. The process of
#initially setting this up is annoying, but worth it.

#Download Rtools: https://cran.r-project.org/bin/windows/Rtools/
#install.packages(devtools)
#Update all installed packages
#run the following line of code: devtools::install_github("daranzolin/ViewPipeSteps") We are going



cor.test(data = frequency[frequency$author == "Brontë Sisters",],
         ~ proportion + `Jane Austen`)
##

cor.test(data = frequency[frequency$author == "H.G. Wells",],
         ~ proportion + `Jane Austen`)
