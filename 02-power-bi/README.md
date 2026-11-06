# Power BI

**Contribution: a model with drill-through, and statistics the tool performs itself.**

A shared Years lookup joins every fact table, so one slicer drives five visuals — without it a slicer reaches only the table it came from. Year is set to "don't summarize", because left alone Power BI offers the sum of every year, a meaningless figure that looks like data.

The visuals are chosen for what only this tool does: a filled map, a ribbon chart for rank changes, a decomposition tree that picks its own branches, small multiples on a shared axis, and Key Influencers — which states the finding as an English sentence.

[`dax_measures.txt`](dax_measures.txt) — the 18 measures.

**The caveat that has to be said out loud.** Key Influencers finds association, not cause. It is a correlation engine with a confident voice.
