SELECT *
FROM PortfolioProject..COVIDDEATHS
WHERE Continent is not Null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..COVIDVACCINATIONS
--Order By 3,4

--Select Data that we are going to be using 

SELECT Location, Date, total_cases, New_Cases, Total_Deaths, population
FROM PortfolioProject..COVIDDEATHS
Where continent is not null 
Order By 1,2


--Looking at Total Cases vs Total Deaths
--Shows the liklihood of dying if you contract Covid in your country

SELECT Location, Date, total_cases, Total_Deaths, (Total_Deaths/Total_Cases)*100 AS DeathPercentage
FROM PortfolioProject..COVIDDEATHS
WHERE Location like  '%states%'
and continent is not null 
Order By 1,2

--Looking at Total Cases vs Population
--Shows What percentage of the population has contracted Covid

SELECT Location, Date,Population, total_cases, (Total_Cases/Population)*100 AS CasePercentage
FROM PortfolioProject..COVIDDEATHS
--WHERE Location like  '%states%'
Order By 1,2

--Looking at Countries with Highest Infection Rate compared to Population 

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_Cases/Population))*100 AS PercentPopulationInfected
FROM PortfolioProject..COVIDDEATHS
--WHERE Location like  '%states%'
GROUP BY population, location 
Order By PercentPopulationInfected DESC

--Showing Countries with Highest Death Count per Population 

SELECT Location, MAX(CAST(total_deaths as INT)) AS TotalDeathCount 
FROM PortfolioProject..COVIDDEATHS
--WHERE Location like  '%states%'
WHERE Continent is not Null
GROUP BY location 
Order By TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--Global Numbers 

SELECT  SUM(New_Cases) AS TotalCases, SUM(CAST(New_Deaths AS INT)) AS TotalDeaths, SUM(CAST(New_Deaths AS INT))/SUM(New_Cases)*100 AS DeathPercent
FROM PortfolioProject..COVIDDEATHS
--WHERE Location like  '%states%'
WHERE continent is not null 
--GROUP BY DATE
Order By 1,2


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition By  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) *100
From PortfolioProject..COVIDDEATHS dea
JOIN PortfolioProject..COVIDVACCINATIONS vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null 
Order By 2,3

-- Use CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition By  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) *100
From PortfolioProject..COVIDDEATHS dea
JOIN PortfolioProject..COVIDVACCINATIONS vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null 
--Order By 2,3
)
SELECT *, (RollingPeopleVaccinated/Population) *100
FROM PopvsVac

--Temp Table 

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar (255),
location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition By  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) *100
From PortfolioProject..COVIDDEATHS dea
JOIN PortfolioProject..COVIDVACCINATIONS vac
	on dea.location = vac.location 
	and dea.date = vac.date
--WHERE dea.continent is not null 
--Order By 2,3

SELECT *, (RollingPeopleVaccinated/Population) *100
FROM #PercentPopulationVaccinated




--Creating Views to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition By  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) *100
From PortfolioProject..COVIDDEATHS dea
JOIN PortfolioProject..COVIDVACCINATIONS vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null 
--Order By 2,3

Select*
FROM PercentPopulationVaccinated



CREATE VIEW CountryvsTotalDeathCount as
SELECT Location, MAX(CAST(total_deaths as INT)) AS TotalDeathCount 
FROM PortfolioProject..COVIDDEATHS
--WHERE Location like  '%states%'
WHERE continent is not Null
GROUP BY location 


SELECT *
FROM CountryvsTotalDeathCount

CREATE VIEW ContinentalTotalDeathCount as 
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
Group by continent

SELECT *
FROM ContinentalTotalDeathCount

CREATE VIEW PercentPopulationInfected as
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_Cases/Population))*100 AS PercentPopulationInfected
FROM PortfolioProject..COVIDDEATHS
--WHERE Location like  '%states%'
GROUP BY population, location 

SELECT *
FROM PercentPopulationInfected