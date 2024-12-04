library("tidyverse")

# Manually make changes

d = read_csv("data/cards.csv",
             col_types = cols(
               title = col_character(),
               n1 = col_integer(),
               n2 = col_integer(),
               n3 = col_integer(),
               n4 = col_integer(),
               n5 = col_integer(),
               slot1 = col_character(),
               slot2 = col_character(),
               slot3 = col_character(),
               slot4 = col_character(),
               slot5 = col_character(),
               slot6 = col_character(),
               slot7 = col_character(),
               slot8 = col_character(),
               slot9 = col_character(),
               slot10 = col_character(),
               file = col_character()
             )) |>
  mutate(type = gsub("[^a-zA-Z]", "", title),
         number = gsub("[^0-9]", "", title),
         number = as.numeric(number)) |>
  arrange(type, number)

slots <- d |>
  select(type, number, starts_with("slot")) |>
  tidyr::pivot_longer(cols = starts_with("slot"), 
                      names_to = "slot",
                      values_to = "color") |>
  mutate(slot = as.numeric(gsub("slot", "", slot))) |>
  arrange(type, number, slot)

targets <- d |>
  select(type, number, n1:n5) |>
  tidyr::pivot_longer(cols = n1:n5, 
                      names_to = "target",
                      values_to = "count") |>
  mutate(target = as.numeric(gsub("n", "", target))) |>
  arrange(type, number, target)


# Have correct number of marbles in targets
targets |>
  group_by(type, number) |>
  summarize(count = sum(count),
            .groups = "drop") |>
  filter(count != 8)

# Have correct number of each color tile
# count colors
count_colors <- function(colors) {
  data.frame(n_blue = sum(colors == "blue"),
             n_pink = sum(colors == "pink"),
             n_yellow = sum(colors == "yellow"),
             n_orange = sum(colors == "orange"))
}

d |>
  filter(type == "Solution") |>
  group_by(type, number) |>
  do(count_colors(.)) |>
  mutate(correct = 
           n_blue == 3 &
           n_pink == 3 &
           n_yellow == 2 &
           n_orange == 2) |>
  filter(!correct)


# Have correct challenge/solution combination
# targets
targets |>
  pivot_wider(id_cols = c(number, target),
              names_from = type,
              values_from = count) |>
  mutate(diff = Challenge - Solution) |>
  filter(diff != 0)


# slots
slots |>
  pivot_wider(id_cols = c(number, slot),
              names_from = type,
              values_from = color) |>
  filter(Challenge != "blank") |>
  filter(Challenge != Solution)


# Random checks for correct solutions
for (i in 1:64) {
  print(targets |> filter(number == i, type == "Solution"))
  readline("next")
  print(slots |> filter(number == i, type == "Solution"))
  readline("next")
}


permutations <- function(x) {
  x <- na.omit(x)
  factorial(sum(x)) / prod(factorial(x))
}

# Relationship between "difficulty" and challenge number
difficulty <- function(d) {
  data.frame(
    n_missing  = sum(d[3:6]),
    difficulty = permutations(d[3:6])
  )
}

tmp = d |>
  filter(type == "Challenge") |>
  group_by(type, number) |>
  do(count_colors(.)) |>
  mutate(n_blue = 3-n_blue,
         n_pink = 3-n_pink,
         n_orange = 2-n_orange,
         n_yellow = 2-n_yellow) |>
  do(difficulty(.))
  
ggplot(tmp, 
       aes(x = number,
           y = difficulty)) +
  geom_point() +
  scale_y_log10() +
  labs(
    x = "Challenge",
    y = "Difficulty",
    title = "Marble Circuit Challenge Difficulty"
  ) +
  # scale_color_gradient2(low = 'green', mid = 'yellow', high = 'red') + 
  theme_bw()
