SELECT *
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
ORDER BY 3, 4

/*SELECT *
FROM `coursera-work-351201.Covid_Stats.Covid_Vaccinations`
ORDER BY 3, 4*/


--Select data
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
ORDER BY 1, 2


--Toal Cases vs Total Deaths
--Chance of death if infected with covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageDead
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
WHERE location = 'United States'
ORDER BY 1, 2


--Total Cases vs Population
--Percentage of population infected
SELECT location, date, total_cases, population, (total_cases/population)*100 as PercentageInfected
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
ORDER BY 1, 2


--Countries w/ Highest Infection Percentage
SELECT location, Max(total_cases), population, Max((total_cases/population))*100 as PercentageInfected
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
GROUP BY location, population
ORDER BY PercentageInfected desc


--Countries w/ Highest Death Count
SELECT location, Max(total_deaths) as TotalDeathCount
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc


--Continent-based Covid Death Count
SELECT continent, Max(total_deaths) as TotalDeathCount
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- Global Daily New Cases vs New Deaths
SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/NULLIF(SUM(new_cases),0)*100 as DeathPercentage
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2




--Total Population vs Vaccination
--Joined covid deaths and covid vaccination by date and location
SELECT `coursera-work-351201.Covid_Stats.Covid_Deaths`.continent, `coursera-work-351201.Covid_Stats.Covid_Deaths`.location, `coursera-work-351201.Covid_Stats.Covid_Deaths`.date, `coursera-work-351201.Covid_Stats.Covid_Deaths`.population, `coursera-work-351201.Covid_Stats.Covid_Vaccinations`.new_vaccinations, SUM(`coursera-work-351201.Covid_Stats.Covid_Vaccinations`.new_vaccinations) OVER (PARTITION BY `coursera-work-351201.Covid_Stats.Covid_Deaths`.location ORDER BY `coursera-work-351201.Covid_Stats.Covid_Deaths`.location, `coursera-work-351201.Covid_Stats.Covid_Deaths`.date) as Rolling_Vaccinations
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
JOIN `coursera-work-351201.Covid_Stats.Covid_Vaccinations`
ON    `coursera-work-351201.Covid_Stats.Covid_Deaths`.location = `coursera-work-351201.Covid_Stats.Covid_Vaccinations`.location
AND `coursera-work-351201.Covid_Stats.Covid_Deaths`.date = `coursera-work-351201.Covid_Stats.Covid_Vaccinations`.date
WHERE `coursera-work-351201.Covid_Stats.Covid_Deaths`.continent is not null
ORDER BY 2, 3









--USE CTE

WITH CTE_PopvsVac AS(
SELECT `coursera-work-351201.Covid_Stats.Covid_Deaths`.continent, `coursera-work-351201.Covid_Stats.Covid_Deaths`.location, `coursera-work-351201.Covid_Stats.Covid_Deaths`.date, `coursera-work-351201.Covid_Stats.Covid_Deaths`.population, `coursera-work-351201.Covid_Stats.Covid_Vaccinations`.new_vaccinations, SUM(`coursera-work-351201.Covid_Stats.Covid_Vaccinations`.new_vaccinations) OVER (PARTITION BY `coursera-work-351201.Covid_Stats.Covid_Deaths`.location ORDER BY `coursera-work-351201.Covid_Stats.Covid_Deaths`.location, `coursera-work-351201.Covid_Stats.Covid_Deaths`.date) as Rolling_Vaccinations
FROM `coursera-work-351201.Covid_Stats.Covid_Deaths`
JOIN `coursera-work-351201.Covid_Stats.Covid_Vaccinations`
ON    `coursera-work-351201.Covid_Stats.Covid_Deaths`.location = `coursera-work-351201.Covid_Stats.Covid_Vaccinations`.location
AND `coursera-work-351201.Covid_Stats.Covid_Deaths`.date = `coursera-work-351201.Covid_Stats.Covid_Vaccinations`.date
WHERE `coursera-work-351201.Covid_Stats.Covid_Deaths`.continent is not null
ORDER BY 2, 3)

SELECT *, (Rolling_Vaccinations/population)*100 AS RV_Percentage
FROM CTE_PopvsVac
