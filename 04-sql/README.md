# SQL

**Status: not built yet.**

The plan for this one is to import the ONS tables completely untouched, titles, notes and all, then clean them with queries rather than by hand. Keeping only rows whose first value looks like a four digit year drops every title and footnote in a single condition, and it keeps working when ONS moves things around.

[`queries.sql`](queries.sql) holds the prepared script, written as a set of steps to follow. It has not been run end to end yet, so no number in it has been checked.

I will rewrite this page with the actual results once the episode is done.
