# End-to-End Sales Data Analysis and Visualization Using Snowflake and Power BI
<p align="center"> <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/> <img src="https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white"/> <img src="https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white"/> <img src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/> </p>

📘 Project Overview

This project demonstrates a complete Sales Data Analytics pipeline integrating Python, Snowflake, SQL, and Power BI.
It covers the entire lifecycle from data generation to cloud loading, transformation, and interactive visualization. The project implements a Snowflake Schema model to normalize dimensions and improve scalability, flexibility, and performance.

🎯 Objective

To build a cloud-based analytics pipeline that:

Generates synthetic sales and dimensional data using Python.

Loads and models the data in Snowflake using SnowSQL CLI.

Applies Snowflake Schema for normalized relationships.

Performs 25+ ad-hoc SQL queries for analysis.

Visualizes insights through a Power BI dashboard.

🧱 Project Architecture

System Flow:

Python → Generate sales, product, customer, and region data using Faker and Random.

SnowSQL CLI → Stage CSVs locally and upload to Snowflake using PUT and COPY INTO.

Snowflake Schema → Organize data into Fact (Sales) and Dimension tables (Customer, Product, Region, Date).

SQL Analysis → Perform 25+ ad-hoc queries for insights and validations.

Power BI → Connect to Snowflake, create KPIs, DAX measures, and dashboards


📂 Repository Structure

├── 📁 01_Data_Generation

│   └── Python scripts for synthetic data creation using Faker and Random.

├── 📁 02_Data_Staging_and_Loading

│   └── CSV files and SnowSQL scripts for staging and loading into Snowflake.

├── 📁 03_Adhoc_SQL_Analysis

│   └── 25+ SQL queries for analytical reporting and testing.

├── 📁 04_PowerBI_Dashboard

│   └── Power BI (.pbix) file with visuals, DAX measures, and KPIs.

└── 📄 README.md

🧰 Tools and Technologies

| Category                      | Tools / Technologies              |
| ----------------------------- | --------------------------------- |
| **Programming**               | Python (`Faker`, `Random`)        |
| **Cloud Data Warehouse**      | Snowflake                         |
| **Querying & Transformation** | SQL                               |
| **ETL Interface**             | SnowSQL CLI                       |
| **Schema Design**             | **Snowflake Schema** (`Normalized`) |
| **Visualization**             | Power BI (`DAX`, `KPIs`, `Dashboards`)  |

📊 Power BI Dashboard

<img width="1347" height="751" alt="image" src="https://github.com/user-attachments/assets/58ee8624-4df2-4878-8ccd-7886b85427d5" />


