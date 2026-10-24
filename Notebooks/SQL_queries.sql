
use banking_analytics;

/* module 1: customer analysis */

/* q1. which districts have the most customers?
   purpose: understand the geographic distribution of customers. */
select d.a2 as district_name, count(c.client_id) as total_customers
from client c
join district d on c.district_id = d.a1
group by d.a2
order by total_customers desc;

-- top 5 districts by customer count and percentage
select d.a2 as district_name,
       count(c.client_id) as total_customers,
       round(count(c.client_id) * 100.0 / (select count(*) from client), 2) as customer_percentage
from client c
join district d on c.district_id = d.a1
group by d.a2
order by total_customers desc
limit 5;

-- average salary per district
select
    d.a2 as district_name,
    d.a11 as average_salary,
    count(c.client_id) as total_customers
from district d
left join client c
    on d.a1 = c.district_id
group by d.a1, d.a2, d.a11
order by total_customers desc;



/* q2. what is the gender distribution of customers?
   purpose: understand the gender composition of customers. */
select case when substring(cast(birth_number as char), 3, 2) > 50 then 'female' else 'male' end as gender,
    count(*) as total_customers
from client
group by gender;


/* q3. how does average customer age vary by district?
   purpose: compare customer age profiles across districts.
   age is calculated as of 31 december 2022. */
select d.a2 as district_name,
       avg(2022 - (1900 + floor(c.birth_number / 10000))) as average_age
from client c
join district d on c.district_id = d.a1
group by d.a2
order by average_age desc;


/* module 2: transaction analysis */
/* q4. how many transactions were recorded each year?
   purpose: identify changes in annual transaction volume. */
select year(date) as transaction_year,
       count(*) as total_transactions
from transactions_combined
group by year(date)
order by transaction_year;

-- monthly transaction trends
select year(`date`) as transaction_year,
       month(`date`) as transaction_month,
       count(*) as total_transactions
from transactions_combined
group by year(`date`), month(`date`)
order by transaction_year, transaction_month;



/* q5. how do transaction counts and amounts differ by type?
   purpose: compare transaction frequency and recorded amounts. */
-- transaction summary by type
select type as transaction_type,
       count(*) as transaction_count,
       sum(amount) as total_amount,
       avg(amount) as average_amount,
       round(count(*) * 100.0 / (select count(*) from transactions_combined), 2) as transaction_percentage
from transactions_combined
group by type
order by transaction_count desc;

-- transaction summary by operation
select
    operation,
    count(*) as total_transactions,
    round(avg(amount), 2) as average_amount,
    round(sum(amount), 2) as total_amount
from transactions_combined
group by operation
order by total_amount desc;

/* q6. which months have the highest transaction activity?
   purpose: identify busy months and possible seasonal patterns. */
select month(date) as transaction_month,
       count(*) as transaction_count
from transactions_combined
group by month(date)
order by transaction_count desc;


/* q7. how does transaction volume change from month to month?
   purpose: compare transaction activity chronologically. */
select year(date) as transaction_year,
       month(date) as transaction_month,
       count(*) as transaction_count
from transactions_combined
group by year(date), month(date)
order by transaction_year, transaction_month;


/* module 3: account and balance analysis */

/* q8. how are accounts distributed by type and frequency?
   purpose: understand the account portfolio. */
select account_type, frequency, count(*) as total_accounts
from account
group by account_type, frequency
order by total_accounts desc;


/* q9. which accounts have the highest latest observed balances?
   purpose: identify accounts with high recorded balances. */
select account_id, date, balance
from transactions_combined
order by date desc, balance desc
limit 20;


/* q10. which transactions have the highest recorded balances?
    purpose: identify high-balance records for further review. */
select account_id, date, balance
from transactions_combined
order by balance desc
limit 20;


/* module 4: loan and card analysis */

/* q11. how many loans are recorded under each status?
    purpose: understand the distribution of loan statuses. */
select status, count(*) as total_loans
from loan
group by status
order by total_loans desc;


/* q12. which loan statuses account for the largest loan amounts?
    purpose: compare loan counts and amounts by status. */
select status,
       count(*) as total_loans,
       sum(amount) as total_loan_amount,
       avg(amount) as average_loan_amount
from loan
group by status
order by total_loan_amount desc;


/* q13. how does the loan portfolio vary by account type?
    purpose: compare loans across different account types. */
select a.account_type,
       count(l.loan_id) as total_loans,
       sum(l.amount) as total_loan_amount
from loan l
join account a on l.account_id = a.account_id
group by a.account_type
order by total_loan_amount desc;


/* q14. which card types are most common?
    purpose: understand the distribution of issued card types. */
select type as card_type, count(*) as total_cards
from card
group by type
order by total_cards desc;


/* module 5: diagnostic analysis and business opportunities */

/* q15. which accounts have the fewest recorded transactions?
    purpose: identify low-activity accounts for further review. */
select a.account_id,
       count(t.trans_id) as total_transactions
from account a
left join transactions_combined t on a.account_id = t.account_id
group by a.account_id
order by total_transactions
limit 20;

/* q16. which transactions have the largest recorded amounts?
    purpose: identify high-value transactions for further review. */
select trans_id, account_id, date, type, amount
from transactions_combined
order by amount desc
limit 20;

/* q17. which districts have high average salaries but relatively few customers?
    purpose: identify districts for possible market-opportunity analysis. */
select d.a2 as district_name,
       d.a11 as average_salary,
       count(c.client_id) as total_customers
from district d
left join client c on d.a1 = c.district_id
group by d.a1, d.a2, d.a11
order by average_salary desc, total_customers asc;

/*Q18. What proportion of transaction records have missing key values?
Purpose: assess data quality before drawing business conclusions. */

select count(*) as total_rows,
       sum(trans_id is null) as missing_transaction_ids,
       sum(account_id is null) as missing_account_ids,
       sum(date is null) as missing_dates,
       sum(amount is null) as missing_amounts
from transactions_combined;

/* Q19. Which transaction types have the highest average amounts?
Purpose: identify transaction categories with larger average values.*/

select type as transaction_type,
       count(*) as transaction_count,
       round(avg(amount), 2) as average_amount
from transactions_combined
group by type
order by average_amount desc;


/* Q20. Which accounts have no recorded transactions?
Purpose: identify accounts with no matching records in the transaction dataset.
*/

select a.account_id, a.account_type
from account a
left join transactions_combined t
    on a.account_id = t.account_id
where t.account_id is null;