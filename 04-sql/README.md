# SQL

**Contribution: it shows what every other tool here is doing underneath.**

The raw tables are imported untouched — titles, notes and all — and cleaned by query. Rows are kept only where the first value looks like a four-digit year, which drops every title and footnote in one condition and still works when ONS moves them. There are no row numbers to maintain.

The cross-check is the strongest evidence in the project: two different ONS tables, counted two different ways, agree exactly for every year from 2018 to 2024.

[`queries.sql`](queries.sql) — cleaning, the five answers, window functions for ranking, and the cross-check.

**Honest limitation.** Nothing here is presentable to anyone who does not read SQL. Its value is that every number in every other folder can be traced back to a query in this file.
