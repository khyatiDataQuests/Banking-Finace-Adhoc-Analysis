# Czechoslovakia Banking — Financial Data Analysis

## Project Overview

This project explores a relational banking dataset from the Czech Financial Dataset (real anonymized transactions). The aim is to use SQL to answer practical business questions about customer demographics, transaction activity, account types, cards, loans, and district-level characteristics.

The project follows an **ad-hoc data analysis** approach: start with a business question, query the relevant tables, interpret the results, and identify what the bank could investigate or improve next.

## Business Problem

The bank wants to understand its customer base and financial activity, identify trends and patterns, and find areas that may deserve further investigation. The analysis focuses on questions such as:

- How is the customer base distributed across districts and gender?
- How does transaction activity vary by year, month, and transaction type?
- Which account frequencies and card types are most common?
- How is the loan portfolio distributed across loan statuses and account types?
- Which districts combine higher average salaries with comparatively smaller customer bases?
- Are there data-quality issues that should be considered before drawing conclusions?

## Dataset

The dataset contains eight related tables:

| Table | Description |
|---|---|
| `client` | Customer identifiers, encoded birth information, and district identifiers |
| `account` | Account identifiers, district, statement frequency, and account opening date |
| `disp` / `disposition` | Relationships between clients and accounts |
| `district` | District names and demographic/economic indicators |
| `card` | Card type, issue date, and related disposition |
| `loan` | Loan amount, duration, payments, status, and associated account |
| `orders` / `order` | Standing orders and their payment details |
| `transactions_combined` / `transactions` | Transaction date, type, operation, amount, balance, and related account |

> **Note:** Table names can differ depending on how the CSV files were imported into MySQL. Update the names in this README if your final database uses different names.

The transaction files used in the analysis cover **2016–2021**. The yearly results therefore represent the available records in those calendar years; they should not automatically be interpreted as full-year or like-for-like growth without checking data coverage.

## Tools Used

- **MySQL**
- **MySQL Workbench**
- **SQL** for joins, aggregation, grouping, filtering, and data-quality checks
- **Microsoft Excel** to review and organize query outputs

## Analysis Workflow

1. **Understand the business questions** and identify the tables needed for each question.
2. **Inspect the tables and relationships**, including identifiers and join keys.
3. **Run data-quality checks** for missing key fields and transaction coverage.
4. **Write focused SQL queries** using joins, `group by`, aggregate functions, `case`, and date functions.
5. **Review the query outputs** and compare patterns across customer, transaction, account, card, loan, and district data.
6. **Translate results into business implications**, while avoiding unsupported claims about profitability, fraud, or causation.

## Analysis Modules

The project includes the following analyses:

### 1. Customer Demographics
- Customer counts by district
- Gender distribution
- Average customer age by district

### 2. Transaction Trends
- Transaction counts by year
- Transaction counts and average amounts by transaction type
- Monthly transaction activity and trends

### 3. Accounts and Balances
- Account distribution by statement frequency and account type
- Latest observed transaction balance by account
- Accounts with relatively low transaction activity

### 4. Loans and Cards
- Number of loans by status
- Total and average loan amount by status
- Loan distribution by account type
- Card counts by card type

### 5. District and Transaction Review
- Districts with higher average salary and comparatively fewer customers
- Largest recorded transactions for review
- Average transaction amount by type
- Data-quality checks, including accounts with no recorded transactions

## Selected Findings from the Current Query Results

These findings describe the current SQL output workbook and should be rechecked if the data or queries change.

- **Customer distribution:** Hl.m. Praha has the largest customer count in the district results, with 663 customers.
- **Gender distribution:** The results show 2,724 male customers (50.74%) and 2,645 female customers (49.26%).
- **Transaction activity:** The combined transaction results contain 1,048,575 rows. The largest yearly count in the current output is 314,532 transactions in 2021.
- **Transaction types:** Withdrawals are more frequent than credits in the current results. Credits have a higher average recorded transaction amount than withdrawals.
- **Loan portfolio:** Status C is the largest loan group in the results, with 403 loans. Status codes should be interpreted using the dataset documentation rather than assumed business labels.
- **Card types:** Classic cards are the most common in the card table, with 659 cards out of 892.
- **Data quality:** The current transaction quality-check output reports no missing transaction IDs, account IDs, dates, or amounts in the combined table.

These are descriptive findings, not proof of profitability, customer satisfaction, fraud, or causal relationships. For example, transaction amount and account balance alone are not sufficient to calculate bank profit.

## Data Source

Czech Financial Dataset (real anonymized transactions), hosted on Data.world:

https://data.world/lpetrocelli/czech-financial-dataset-real-anonymized-transactions

## Project Goal

The goal of this project is to demonstrate how SQL-based ad-hoc analysis can turn relational banking data into clear, evidence-based findings and practical questions for further business investigation.
