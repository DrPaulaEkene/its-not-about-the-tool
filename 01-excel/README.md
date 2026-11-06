# Excel

**Status: finished.**

Everything starts from the raw ONS download, untouched. Power Query does the cleaning, which matters because it records every step rather than performing it. When next year's file is published I point the query at it and press refresh, and the whole clean runs again in about four seconds.

The four cleaned tables go into the data model rather than onto worksheets. One of them is twenty one thousand rows, and putting that on a sheet makes the workbook slow for no benefit at all.

Five PivotTables answer the five questions, all reading from that one model. Every rate is averaged, never summed. A rate already has the population inside it, so adding two of them together produces a number that means nothing. I learned that the hard way, on camera, when a pivot told me the death rate was over a thousand per hundred thousand.

The lollipop chart is not something Excel offers. I built it from a scatter for the dots and an error bar running backwards for the stick. Excel will combine a column chart with a scatter but not a bar chart with one, and it does not tell you that. The option is simply missing from the menu.

The four numbers across the top are not typed. Each one points at the cell it came from, so they move when the data does.

[`alcohol_deaths_excel.xlsx`](alcohol_deaths_excel.xlsx) is the workbook, with the queries, the model, the pivots and all six panels.
