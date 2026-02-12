# Snowflake + dbt Medallion Architecture

## Overview
This project demonstrates a Medallion Architecture (Bronze → Silver → Gold) using dbt. 
It includes:
- Incremental Bronze tables with deduplication
- Cleaned Silver tables
- Gold layer with fact and dimension tables
- dbt tests for data quality
- Macro for surrogate keys (optional)

## Folder Structure
- models/bronze: raw tables
- models/silver: cleaned and standardized tables
- models/marts/dimensions: dimension tables
- models/marts/facts: fact tables
- macros: reusable macros
- models/sources.yml: source definitions
- models/schema.yml: tests

## How it works
1. Bronze loads raw data and deduplicates
2. Silver cleans and standardizes the data
3. Gold/marts prepares analytics-ready fact and dimension tables

## Notes
- All models can be configured to pull data from local or cloud sources (e.g., GCS)
- Incremental models only load new or updated rows
