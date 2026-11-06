# Data notes

**Source.** Office for National Statistics, *Alcohol-specific deaths in the UK: registered in 2024*. Contains public sector information licensed under the Open Government Licence v3.0.

| Sheet | Contents | Scope | Rows after cleaning |
|---|---|---|---|
| Table_6 | Deaths, age-standardised rate, 95% limits by region, sex, year | England, 9 regions, 2001-2024 | 648 |
| Table_9 | Deaths by cause and 20 age bands | United Kingdom, 15 causes | 1,080 |
| Table_10 | Published share of deaths by cause | United Kingdom | 1,080 |
| Table_11 | Deaths and rates by deprivation fifth | England, 2018-2024 | 35 |

**Definitions in plain words.** *Alcohol-specific* means wholly caused by alcohol, mostly alcoholic liver disease. *Age-standardised* means levelled for age, so regions with older populations are not unfairly penalised. *Year* is the year the death was registered, which can be later than the year it happened.

**Known scope traps.** England 2024 = 7,673 deaths (Table_6). UK 2024 = 9,809 (Table_9). Table_11 starts in 2018, not 2001. Persons already equals Males plus Females.

**Files.** `alcoholspecificdeaths2024.xlsx` is the untouched download. The `clean_*.csv` files are produced by the Python notebook in `06-python/` and are the input for the SQL build.
