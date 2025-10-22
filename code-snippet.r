library(readr)
library(dplyr)
library(tidyr)
library(lubridate)

# ---- Setup and transformation of datasets ---- 
path_to_data <- "https://raw.githubusercontent.com/tdvoronova/masters-thesis/main/df.csv"

df <- readr::read_csv(path_to_data, show_col_types = FALSE) %>%
  mutate(date = as.Date(date)) %>%               # ensure date parsed
  arrange(date) %>%
  mutate(
    war          = as.integer(date >= as.Date("2022-04-01")),
    time         = time_length(interval(min(date), date), unit = "months"),
    shock_spring = as.integer(date >= as.Date("2022-04-01") & date <= as.Date("2022-06-01")),
    shock_winter = as.integer(date >= as.Date("2022-10-01") & date <= as.Date("2023-01-01"))
  ) %>%
  mutate(across(
    c(rent_cpi, total_cpi,
      Tbilisi_CPI, Kutaisi_CPI, Batumi_CPI, Gori_CPI, Telavi_CPI, Zugdidi_CPI,
      Tbilisi_Rent, Kutaisi_Rent, Batumi_Rent, Gori_Rent, Telavi_Rent, Zugdidi_Rent),
    ~ 100 * (. - dplyr::lag(.)) / dplyr::lag(.),
    .names = "{.col}_rate"
  )) %>%
  filter(date > as.Date("2016-01-01") & date <= as.Date("2023-12-01"))


panel <- df %>%
  select(date, war, interest_rate,
         matches("^(Tbilisi|Kutaisi|Batumi|Gori|Telavi|Zugdidi)_(CPI|Rent)(_rate)?$")) %>%
  pivot_longer(-c(date, war, interest_rate),
               names_to = c("city","variable","rate"),
               names_sep = "_", values_to = "value") %>%
  mutate(variable = ifelse(is.na(rate), variable, paste0(variable, "_rate"))) %>%
  select(-rate) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(city = factor(city),
         date = as.Date(date),
         time = time_length(interval(min(date), date), unit = "months"))

# ---- Models ----

## (1) National OLS with controls (Newey–West SEs)
m_national <- lm(rent_cpi_rate ~ war + total_cpi_rate + interest_rate, data = df)
coeftest(m_national, vcov = NeweyWest(m_national, prewhite = FALSE))

## (2) TWFE: city & date FE with interaction for war
m_twfe <- feols(Rent_rate ~ i(city, war, ref = "Tbilisi") + CPI_rate | city + date,
                cluster = ~city, data = panel)
summary(m_twfe)

## (3) Shock model (nationwide)
m_shock <- lm(rent_cpi_rate ~ time + shock_spring + shock_winter + total_cpi_rate + interest_rate, data = df)
coeftest(m_shock, vcov = NeweyWest(m_shock, prewhite = FALSE))

# ---- Visualization: monthly rent growth with shock windows ----
ggplot(df, aes(date, rent_cpi_rate)) +
  geom_line() +
  geom_vline(xintercept = as.Date(c("2022-04-01","2022-06-01","2022-10-01","2023-01-01")),
             linetype = "dashed") +
  labs(x = NULL, y = "Monthly Rent Growth Rate (%)") +
  theme_minimal()
