# Steam Games Market Analysis

A complete end-to-end Data Analytics portfolio project analyzing the Steam Games dataset using **SQL (DuckDB)** and **Tableau Public**.

This project follows the complete data analytics workflow, from business understanding and data preparation to SQL analysis, dashboard development, and strategic recommendations.

A complete end-to-end Data Analytics portfolio project analyzing the Steam Games dataset using SQL (DuckDB) and Tableau Public.



This project follows the full data analytics workflow, from business understanding and data preparation to SQL analysis, dashboard development, and strategic recommendations.



\---



📊 Dashboard Preview



<img width="885" height="715" alt="image" src="https://github.com/user-attachments/assets/1466ad90-8178-4314-a898-fa37ab70ac7a" />




\*\*Interactive Dashboard (Tableau Public):\*\*  



🔗 **Interactive Dashboard (Tableau Public):**  
https://public.tableau.com/app/profile/catalina.herrera1503/viz/SteamMarketTrendsPlayerSatisfaction19972025/Dashboard-SteamGamesAnalysis

---

# Project Overview

Steam hosts thousands of games covering a wide variety of genres, pricing strategies, and publishers.

The objective of this project is to identify which game characteristics are most strongly associated with player satisfaction and market trends using SQL analysis and interactive data visualization.

> **Note:** This is a fictional business scenario created for educational and portfolio purposes.

---

# Business Questions

The analysis focuses on answering the following questions:

- How has the number of Steam game releases evolved over time?
- Which game genres receive the highest player ratings?
- Is there a relationship between game price and player satisfaction?
- Which publishers consistently release highly rated games?

---

# Tools & Technologies

| Tool | Purpose |
|------|---------|
| SQL | Data cleaning & analysis |
| DuckDB | SQL database engine |
| DBeaver | Database management |
| Tableau Public | Dashboard & visualization |
| Git | Version control |
| GitHub | Project portfolio |

---

# 📂 Repository Structure

```text
Steam_Games_Analysis/
│
├── data_raw/
│   └── games.csv
│
├── data_clean/
│   ├── steam_games_clean.csv
│   ├── steam_genres.csv
│   └── top_publishers.csv
│
├── documentation/
│   └── Steam_Games_Market_Analysis.pdf
│
├── screenshots/
│   └── dashboard.png
│
├── sql/
│   └── steam_games_analysis.sql
│
├── tableau/
│   └── Steam Market Trends & Player Satisfaction (1997–2025).twbx
│
└── README.md
```

---

# Data Preparation

The dataset was cleaned and transformed using SQL before the analysis.

Main preparation steps included:

- Import validation
- Column selection based on business objectives
- Data type corrections
- Date transformation
- Creation of analytical variables
- Validation of numeric fields
- Removal of incomplete records
- Publisher normalization for publisher-level analysis

---

# 📈 Key Insights

- **68.6%** of all games in the dataset were released between **2021 and 2025**, highlighting Steam's rapid recent growth.
- **Casual** games achieved the highest average player rating (**81.02%**), closely followed by Adventure and Indie titles.
- Games priced between **$5.00 and $9.99** received the highest average positive review ratio (**82.20%**).
- Premium-priced games (**$60+**) showed comparatively lower average player ratings.
- After normalizing publishers and filtering for at least **10 games** with **100+ reviews**, **27 publishers** achieved an average positive review score above **90%**.

---

# 📊 Dashboard

The interactive Tableau dashboard includes:

- KPI overview
- Annual game releases
- Average player rating by genre
- Player satisfaction by price range
- Top-rated publishers

📍 **View Dashboard:**  
https://public.tableau.com/app/profile/catalina.herrera1503/viz/SteamMarketTrendsPlayerSatisfaction19972025/Dashboard-SteamGamesAnalysis

---

# 📄 Documentation

A complete project report describing the business scenario, data preparation, SQL analysis, dashboard development, and strategic recommendations is available in:

📄 `documentation/Steam_Games_Market_Analysis.pdf`

---

# 📚 Dataset

**Steam Games Dataset**

Source:  
https://www.kaggle.com/datasets/fronkongames/steam-games-dataset

The dataset was created using the Steam Web API and Steam Spy and is publicly available on Kaggle.

---

# Author

**Catalina Herrera**

Data Analytics Portfolio Project

- GitHub: https://github.com/catalinaherreram
- LinkedIn: https://www.linkedin.com/in/catalina-herreram/

---

## Skills Demonstrated

- SQL
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Business Intelligence
- Tableau
- Data Visualization
- Data Storytelling
- Business Recommendations
