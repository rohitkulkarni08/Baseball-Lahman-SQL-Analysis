# Baseball Lahman Analysis

## Project Overview
This project aims to analyze historical baseball data from the Lahman Baseball Database. The analysis focuses on various aspects of the game, including player performance, team statistics, and historical trends.

## Data Set
The data used in this project is sourced from the Lahman Baseball Database, which contains comprehensive records of baseball statistics from the 19th century to the present. 

[Data Source](https://github.com/jknecht/baseball-archive-sqlite](https://github.com/jknecht/baseball-archive-sqlite/releases/tag/2022))

## Key Findings
The analysis is conducted using SQL queries to extract insights from the database. Some of the key areas explored include:

- **Player Performance**: Analysis of player statistics to identify top performers and trends over time.
- **Team Statistics**: Examination of team performance metrics to understand the dynamics of winning teams.
- **Historical Trends**: Investigation of historical trends in the game, such as changes in playing style or strategy.

## SQL Functions Utilized:

| Function                              | Description                                                                                   |
|---------------------------------------|-----------------------------------------------------------------------------------------------|
| Data Aggregation                      | Utilizing functions like COUNT, SUM, AVG, MIN, MAX, and GROUP BY for summarizing data.         |
| Data Ordering                        | Employing HAVING and ORDER BY clauses to sort and filter data based on specific criteria.      |
| Data Manipulation                     | Using functions like JOIN (Right, Left, Inner), UNION, and DISTINCT for combining and restructuring datasets. |
| Window Functions                      | Leveraging functions such as LEAD, LAG, ROW_NUMBER, and RANK for analyzing data in a specified sequence. |
| Subqueries                            | Extracting subsets of data for deeper analysis within the context of larger queries.           |
| Logical Functions                     | Employing CASE WHEN for data categorization and conditional operations based on specified conditions. |
| Common Table Expressions (CTEs)      | Creating temporary result sets for complex queries, enhancing readability and simplifying complex logic. |
| Data Formatting and Transformation   | Utilizing functions like CONCAT, SUBSTRING, and REPLACE for formatting and modifying data values. |
| Alias Usage                           | Enhancing query clarity and readability by assigning aliases to tables and columns.            |
| Query Performance Optimization       | Implementing indexing and query tuning techniques to improve query execution speed and efficiency. |


## Summary of Analyses

Teams and Players Achievements (1980-2022):

- **Focus:** Team and individual player achievements from 1980 to 2022.
- **Teams:** Analyzed based on their total wins and Hall of Fame inductees.
- **Players:** Highlighted for their MVP awards, especially those with multiple wins.
- **Team Performance:** Aggregated by decade, covering wins, losses, win percentage, runs, strikeouts, stolen bases, and on-base percentage.
- **Player Career:** Detailed year-by-year breakdown of Alex Rodriguez's career, including games, batting average, hits, home runs, RBIs, stolen bases, runs, walks, and strikeouts.

Historical and Comparative Team and Player Analysis:

- **Focus:** Analysis of team and player performance over time, with comparisons between different eras or teams.
- **Statistical Categories:** Exploring specific milestones achieved by teams or players.
- **Nuanced Understanding:** Delving into lesser-explored metrics or aspects of the game.

Advanced Player and Team Metrics:

- **Focus:** Exploration of advanced or specific metrics related to player and team performance.
- **Statistical Analysis:** Emphasis on techniques to draw deeper insights into player abilities and team strategies.
- **Predictive Modeling:** Analysis of trends to forecast future performance based on historical data.

