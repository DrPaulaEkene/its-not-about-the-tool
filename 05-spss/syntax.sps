* =====================================================================.
* IT'S NOT ABOUT THE TOOL (v2)  |  Episode: SPSS.
* Four ONS sheets: Table_6, Table_9, Table_10, Table_11.
* HOW TO RUN: File > Open > Syntax > this file, then Run > All.
* Edit FILE_PATH below if your workbook is somewhere else.
* =====================================================================.

DEFINE !F () 'C:\Users\eanug\Downloads\Data-Diary-Lab\Its_Not_About_The_Tool_v2\alcoholspecificdeaths2024.xlsx' !ENDDEFINE.

* ---------- TABLE 6: England regions. Data sits in A6:H653 ----------.
GET DATA /TYPE=XLSX /FILE=!F /SHEET=NAME 'Table_6'
  /CELLRANGE=RANGE 'A6:H653' /READNAMES=OFF /ASSUMEDSTRWIDTH=40.
DATASET NAME regions WINDOW=FRONT.
RENAME VARIABLES (V1 V2 V3 V4 V5 V6 V7 V8 = Year Sex AreaCode Region Deaths Rate LCL UCL).
ALTER TYPE Year Deaths (F6.0) Rate LCL UCL (F5.1).
COMPUTE Sex = LTRIM(RTRIM(Sex)).
COMPUTE Region = LTRIM(RTRIM(Region)).
SELECT IF (NOT MISSING(Year)).
EXECUTE.
* CHECK: expect 648 cases, Sex 216 each, 9 regions.
FREQUENCIES VARIABLES=Sex Region.

* ---------- TABLE 9: causes by age, UK. Data sits in A5:AA1084 ----------.
GET DATA /TYPE=XLSX /FILE=!F /SHEET=NAME 'Table_9'
  /CELLRANGE=RANGE 'A5:AA1084' /READNAMES=OFF /ASSUMEDSTRWIDTH=80.
DATASET NAME causes WINDOW=FRONT.
RENAME VARIABLES (V1 V2 V3 V4 V5 V6 = AreaCode Area Year Sex ICD Cause).
RENAME VARIABLES (V7 V8 V9 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V20 V21 V22 V23 V24 V25 V26 V27
  = Age01 Age02 Age03 Age04 Age05 Age06 Age07 Age08 Age09 Age10
    Age11 Age12 Age13 Age14 Age15 Age16 Age17 Age18 Age19 Age20 TotalDeaths).
ALTER TYPE Year TotalDeaths Age01 TO Age20 (F8.0).
COMPUTE Sex = LTRIM(RTRIM(Sex)).
SELECT IF (NOT MISSING(Year)).
EXECUTE.
* CHECK: expect 1080 cases.

* ---------- TABLE 10: published cause shares, UK. A5:G1084 ----------.
GET DATA /TYPE=XLSX /FILE=!F /SHEET=NAME 'Table_10'
  /CELLRANGE=RANGE 'A5:G1084' /READNAMES=OFF /ASSUMEDSTRWIDTH=80.
DATASET NAME shares WINDOW=FRONT.
RENAME VARIABLES (V1 V2 V3 V4 V5 V6 V7 = AreaCode Area Year Sex ICD Cause Proportion).
ALTER TYPE Year (F6.0) Proportion (F5.1).
COMPUTE Sex = LTRIM(RTRIM(Sex)).
SELECT IF (NOT MISSING(Year)).
EXECUTE.

* ---------- TABLE 11: deprivation, England. A5:J39 ----------.
GET DATA /TYPE=XLSX /FILE=!F /SHEET=NAME 'Table_11'
  /CELLRANGE=RANGE 'A5:J39' /READNAMES=OFF /ASSUMEDSTRWIDTH=40.
DATASET NAME imd WINDOW=FRONT.
RENAME VARIABLES (V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 =
  Year IMD MaleDeaths MaleRate MaleLCL MaleUCL FemaleDeaths FemaleRate FemaleLCL FemaleUCL).
ALTER TYPE Year IMD MaleDeaths FemaleDeaths (F8.0) MaleRate FemaleRate MaleLCL MaleUCL FemaleLCL FemaleUCL (F5.1).
SELECT IF (NOT MISSING(Year)).
EXECUTE.
* CHECK: expect 35 cases (7 years x 5 quintiles).

* ================= Q1: WHERE (regions, 2024) =================.
DATASET ACTIVATE regions.
DATASET COPY y2024.
DATASET ACTIVATE y2024.
SELECT IF (Year = 2024 AND Sex = 'Persons').
SORT CASES BY Rate (D).
LIST Region Deaths Rate LCL UCL.
* Expect North East 21.1 (19.4 to 22.9) top; London 10.9 bottom.
GRAPH /BAR(SIMPLE)=MEAN(Rate) BY Region /TITLE='Rate per 100,000 by region, 2024'.
GRAPH /HILO(SIMPLE)=VALUE(UCL LCL Rate) BY Region /TITLE='2024 rate with 95% range'.

* ================= Q2: WHEN (England trend) =================.
DATASET ACTIVATE regions.
TEMPORARY.
SELECT IF (Sex = 'Persons').
GRAPH /LINE(SIMPLE)=SUM(Deaths) BY Year /TITLE='Deaths per year, England regions'.
* Expect 5,820 (2019), 8,276 (2023), 7,673 (2024).

* ================= Q3: WHAT (causes, UK 2024) =================.
DATASET ACTIVATE causes.
TEMPORARY.
SELECT IF (Year = 2024 AND Sex = 'Persons' AND TotalDeaths > 0).
GRAPH /BAR(SIMPLE)=SUM(TotalDeaths) BY Cause /TITLE='UK deaths by cause, 2024'.
DATASET ACTIVATE shares.
TEMPORARY.
SELECT IF (Year = 2024 AND Sex = 'Persons' AND Proportion > 1).
LIST Cause Proportion.
* Expect alcoholic liver disease 74.3%, mental and behavioural 15.4%.
TEMPORARY.
SELECT IF (ICD = 'K70' AND Sex = 'Persons').
GRAPH /LINE(SIMPLE)=MEAN(Proportion) BY Year /TITLE='Liver disease share of UK deaths'.

* ================= Q4: WHO (age at death, UK 2024) =================.
* VARSTOCASES turns the 20 age columns into 20 rows, which is what charts need.
DATASET ACTIVATE causes.
DATASET COPY ages.
DATASET ACTIVATE ages.
SELECT IF (Year = 2024 AND Sex = 'Persons').
VARSTOCASES /MAKE Deaths FROM Age01 TO Age20 /INDEX=AgeBand(Deaths) /DROP=TotalDeaths.
VALUE LABELS AgeBand 1 '<1' 2 '1-4' 3 '5-9' 4 '10-14' 5 '15-19' 6 '20-24' 7 '25-29'
  8 '30-34' 9 '35-39' 10 '40-44' 11 '45-49' 12 '50-54' 13 '55-59' 14 '60-64'
  15 '65-69' 16 '70-74' 17 '75-79' 18 '80-84' 19 '85-89' 20 '90+'.
GRAPH /BAR(SIMPLE)=SUM(Deaths) BY AgeBand /TITLE='UK deaths by age band, 2024'.
* Expect the 55-59 band highest (1,651 deaths, 16.8% of the UK total).

* ================= Q5: DEPRIVATION (England 2024) =================.
DATASET ACTIVATE imd.
TEMPORARY.
SELECT IF (Year = 2024).
LIST IMD MaleDeaths MaleRate FemaleDeaths FemaleRate.
* Expect men 35.7 (most deprived) vs 9.0 (least) = 3.97 times; women 15.4 vs 5.1 = 3.02.
TEMPORARY.
SELECT IF (Year = 2024).
GRAPH /BAR(GROUPED)=MEAN(MaleRate) MEAN(FemaleRate) BY IMD
  /TITLE='Rate by deprivation quintile, England 2024'.

* CHART EDITOR: double-click any chart to sort bars, recolour one bar,
* add data labels, then right-click > Export to save a PNG for your portfolio.

* ============== SPOTLIGHT: what only SPSS does best ==============.
* Formal testing. The other tools describe the gap; SPSS puts a number on how
* unlikely it would be by chance, and estimates how steep the gradient is.

* T1. Is the male-female gap across regions real? Paired-samples t-test, 2024.
* Each region supplies one male and one female rate, so the pairs are matched.
DATASET ACTIVATE regions.
DATASET COPY sexwide.
DATASET ACTIVATE sexwide.
SELECT IF (Year = 2024 AND Sex <> 'Persons').
SORT CASES BY Region Sex.
CASESTOVARS /ID=Region /INDEX=Sex /DROP=Year AreaCode Deaths LCL UCL.
T-TEST PAIRS=Rate.Males WITH Rate.Females (PAIRED) /CRITERIA=CI(.95).
* Expect: men 19.5 vs women 9.8, difference 9.7, t(8) = 18.0, Sig. .000 (p < .001).
* Say it in plain words: "If men and women really had the same rate, a gap this
* big in all nine regions would almost never happen by chance."

* T2. How steep is the deprivation gradient? Regression of rate on quintile, 2024.
DATASET ACTIVATE imd.
DATASET COPY grad.
DATASET ACTIVATE grad.
SELECT IF (Year = 2024).
EXECUTE.
REGRESSION /DEPENDENT MaleRate /METHOD=ENTER IMD /STATISTICS=COEFF R ANOVA.
REGRESSION /DEPENDENT FemaleRate /METHOD=ENTER IMD /STATISTICS=COEFF R ANOVA.
* Read B for IMD: the fall in deaths per 100,000 for each step towards the least
* deprived fifth. R Square tells you how much of the pattern the gradient explains.
* Expect: men B = -6.3 per step towards the least deprived fifth (R Square 0.91, p = .012);
* women B = -2.5 (R Square 0.94, p = .006).
* Caveat for camera: five points only, and these are areas, not people.
GRAPH /SCATTERPLOT(BIVAR)=IMD WITH MaleRate /TITLE='Male rate by deprivation fifth, 2024'.
* In the Chart Editor: Elements > Fit Line at Total > Linear.
DATASET ACTIVATE regions.
