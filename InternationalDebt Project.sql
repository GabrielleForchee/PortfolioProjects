Select *
from international_debt
limit 10


--Looking at what the total number of debt and debt indicators to then indicate the total amount of global debt.
Select COUNT(DISTINCT Country_Name) AS Total_Distinct_Countries
from international_debt

Select Distinct(indicator_code) AS Distinct_Debt_Indicators
From international_debt
Order by Distinct_Debt_Indicators

Select Round(Sum(debt)/1000000,2) AS Total_Debt
From International_Debt\

-- Pinpointing which country owns the highest amount of debt...We can see that China is a the leading debt carrying country.
SELECT country_name, SUM(debt) AS Total_Debt
FROM international_debt
GROUP BY country_Name
ORDER BY total_debt desc

--Figuring out on average how much debt a country owes.
SELECT indicator_code AS debt_indicator,
indicator_name, 
AVG(debt) AS Average_Debt
FROM international_debt
GROUP BY debt_indicator, indicator_name
ORDER BY Average_debt desc
Limit 10;


--We can investigate this a bit more so as to find out which country owes the highest amount of debt in the category of long term debts (DT.AMT.DLXF.CD). Since not all the countries suffer from the same kind of economic disturbances, this finding will allow us to understand that particular country's economic condition a bit more specifically.
SELECT Country_name, indicator_name
FROM international_debt
WHERE debt = (SELECT 
MAX(debt)
FROM international_debt
Where indicator_code= 'DT.AMT.DLXF.CD');


--We saw that long-term debt is the topmost category when it comes to the average amount of debt. But is it the most common indicator in which the countries owe their debt?
Select indicator_code, COUNT(*) AS Indicator_Count
From international_debt
group by indicator_code
order by indicator_count desc, indicator_code desc
limit 20;

-- Let's find out the maximum amount of debt that each country has.
select country_name, MAX(debt) AS Maximum_debt
from international_debt
group by country_name
order by maximum_debt desc
limit 10