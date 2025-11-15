# Tokyo-Olympics-Data-Analytics-On-Azure

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)](https://databricks.com/)
[![Azure Data Factory](https://img.shields.io/badge/Azure_Data_Factory-0078D4?style=for-the-badge&logo=azuredatafactory&logoColor=white)](https://azure.microsoft.com/en-us/services/data-factory/)
[![Azure Synapse Analytics](https://img.shields.io/badge/Azure_Synapse_Analytics-0078D4?style=for-the-badge&logo=azuresynapseanalytics&logoColor=white)](https://azure.microsoft.com/en-us/services/synapse-analytics/)


<img width="1085" height="192" alt="image" src="https://github.com/user-attachments/assets/34c2db84-96ca-4bdd-922d-b97b1de2d357" />

## 🎯 Project Overview

This project demonstrates a complete **cloud-based data engineering solution** for analyzing Tokyo 2020 Olympics data using Microsoft Azure services. The implementation showcases modern data engineering practices including data ingestion, transformation, storage, analytics, and visualization.

**Key Objectives:**
- Build a scalable ETL pipeline using Azure cloud services
- Transform raw Olympic data into analytics-ready formats
- Perform advanced SQL analytics on structured data
- Create interactive dashboards for data visualization

## 🏗️ Architecture

![Project Architecture](assets/olympic-azure-architecture.png)

### Data Flow
```
Kaggle Dataset → GitHub (Raw Data) → Azure Data Factory → Azure Data Lake Gen2 (Raw)
                                              ↓
                                    Azure Databricks (PySpark)
                                              ↓
                          Azure Data Lake Gen2 (Transformed)
                                              ↓
                                    Azure Synapse Analytics
```

## 🛠️ Technologies Used

### Azure Services

| Service | Purpose |
|---------|---------|
| **Azure Data Factory** | Orchestrate and automate data pipelines |
| **Azure Data Lake Gen2** | Scalable storage for raw and transformed data |
| **Azure Databricks** | Distributed data processing with Apache Spark |
| **Azure Synapse Analytics** | Cloud data warehouse for analytics |

### Data Processing & Analytics
- **PySpark** - Large-scale data transformation
- **SQL** - Advanced querying and analysis

## 📊 Data Source

link : https://www.kaggle.com/datasets/arjunprasadsarkhel/2021-olympics-in-tokyo/data
The Tokyo 2020 Olympics dataset is sourced from Kaggle and includes:
- **Athletes** - Competitor information by country and discipline
- **Coaches** - Coaching staff details
- **Teams** - Team compositions and events
- **Medals** - Medal counts by country
- **Gender Statistics** - Participation breakdown by gender

**Format:** CSV files  
**Storage:** Azure Data Lake Gen2

## 🔄 ETL Pipeline

### 1️⃣ Extract
- Azure Data Factory pipeline pulls raw CSV data from GitHub
- Data is ingested into Azure Data Lake Gen2 (raw zone)
- Automated scheduling ensures data freshness
<img width="1880" height="930" alt="Screenshot 2025-11-14 023916" src="https://github.com/user-attachments/assets/8068b4fa-1bc9-4df9-846a-418bafcb6f2d" />


### 2️⃣ Transform
- Azure Databricks processes data using PySpark
- Transformations include:
  - Data cleaning and validation
  - Schema standardization
  - Feature engineering
  - Aggregations and calculations
- Transformed data stored in Azure Data Lake Gen2 (curated zone)

### 3️⃣ Load
- Processed data loaded into Azure Synapse Analytics
- Star schema design for optimized querying
- Partitioned tables for performance

### 4️⃣ Analyze
- SQL queries for deep insights:
  - Medal analysis and rankings
  - Gender participation trends
  - Country performance metrics
  - Discipline popularity analysis

## 📈 Synapse Analytics Queries

- **Medal Analysis** - Top performing countries, medal efficiency
- **Athlete Insights** - Participation by country and discipline
- **Gender Balance** - Distribution across sports
- **Performance Metrics** - Medals per athlete ratios
- **Comparative Analysis** - Regional and discipline-level statistics

## 📊 Sample Insights

- 🥇 Top 10 medal-winning countries
- 👥 Gender participation balance by discipline
- 🌍 Regional performance analysis
- 🏃 Athlete-to-coach ratios by country
- 📈 Medal efficiency metrics

## 📝 Project Status

| Component | Status |
|-----------|--------|
| Data Ingestion | ✅ Complete |
| ETL Pipeline | ✅ Complete |
| Data Transformation | ✅ Complete |
| Analytics Queries | ✅ Complete |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
---

**⭐ If you find this project useful, please consider giving it a star!**
