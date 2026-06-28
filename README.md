\# Steam Games Market Analysis



A complete end-to-end Data Analytics portfolio project analyzing the Steam Games dataset using SQL (DuckDB) and Tableau Public.



This project follows the full data analytics workflow, from business understanding and data preparation to SQL analysis, dashboard development, and strategic recommendations.



\---



\## 📊 Dashboard Preview



> \*(Insert dashboard screenshot here)\*



!\[Steam Dashboard](screenshots/dashboard.png)



\*\*Interactive Dashboard (Tableau Public):\*\*  

https://public.tableau.com/app/profile/catalina.herrera1503/viz/SteamMarketTrendsPlayerSatisfaction19972025/Dashboard-SteamGamesAnalysis



\---



\# 📌 Project Overview



Steam hosts thousands of games covering a wide variety of genres, pricing strategies and publishers.



The objective of this project is to identify which game characteristics are most strongly associated with player satisfaction and market trends using SQL analysis and interactive data visualization.



This is a fictional business scenario created for educational and portfolio purposes.



\---



\# Business Questions



The analysis focuses on answering the following questions:



1\. How has the number of Steam game releases evolved over time?

2\. Which game genres receive the highest player ratings?

3\. Is there a relationship between game price and player satisfaction?

4\. Which publishers consistently release highly rated games?



\---



\# Tools \& Technologies



\- SQL

\- DuckDB

\- DBeaver

\- Tableau Public

\- Git

\- GitHub



\---



\# 📂 Repository Structure



```

Steam\_Games\_Analysis/

│

├── data\_raw/

│   └── Original Steam dataset

│

├── data\_clean/

│   ├── steam\_games\_clean.csv

│   ├── steam\_genres.csv

│   └── top\_publishers.csv

│

├── sql/

│   └── steam\_games\_analysis.sql

│

├── tableau/

│   └── Tableau workbook

│

├── documentation/

│   └── Steam\_Games\_Analysis\_Report.pdf

│

├── screenshots/

│   └── dashboard.png

│

└── README.md

```



\---



\# Data Preparation



The dataset was cleaned and transformed using SQL.



Main preparation steps included:



\- Import validation

\- Column selection

\- Data type corrections

\- Date transformation

\- Creation of analytical variables

\- Validation of numeric fields

\- Removal of incomplete records

\- Publisher normalization for publisher-level analysis



\---



\# Key Insights



\- \*\*68.6%\*\* of all games in the dataset were released between \*\*2021 and 2025\*\*, highlighting Steam's rapid recent growth.



\- \*\*Casual\*\* games achieved the highest average player rating (\*\*81.02%\*\*), closely followed by Adventure and Indie titles.



\- Games priced between \*\*$5.00 and $9.99\*\* received the highest average positive review ratio (\*\*82.20%\*\*).



\- Premium-priced games (\*\*$60+\*\*) showed comparatively lower average player ratings.



\- After normalizing publishers and filtering for at least \*\*10 games\*\* with \*\*100+ reviews\*\*, \*\*27 publishers\*\* achieved an average positive review score above \*\*90%\*\*.



\---



\# Dashboard



The Tableau dashboard summarizes the main findings through:



\- KPI overview

\- Annual game releases

\- Average player rating by genre

\- Player satisfaction by price range

\- Top-rated publishers



\---



\# Documentation



A complete project report describing the business scenario, data preparation, SQL analysis, dashboard development and strategic recommendations is available in:



```

documentation/Steam\_Games\_Analysis\_Report.pdf

```



\---



\# Dataset



Steam Games Dataset



Source:

https://www.kaggle.com/datasets/fronkongames/steam-games-dataset



The dataset is publicly available and was created using the Steam Web API and Steam Spy.



\---



\# 👤 Author



\*\*Catalina Herrera\*\*



Data Analytics Portfolio Project



GitHub:

\*https://github.com/catalinaherreram/\*



LinkedIn:

\*https://www.linkedin.com/in/catalina-herreram/\*



\---



\## About this project



This project was developed as part of my Data Analytics portfolio to demonstrate practical skills in:



\- SQL

\- Data Cleaning

\- Exploratory Data Analysis

\- Business Intelligence

\- Tableau

\- Data Storytelling

