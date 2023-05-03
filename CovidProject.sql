Select *
From Covid_Project..covid_worldwide$
order by 1,2



Select *
From Covid_Project..CovidDeaths$
order by 1,2



Select Country, [Total Deaths], [Total Cases], [Active Cases], Population
From Covid_Project..covid_worldwide$
order by 1,2



Select continent, location, date, total_vaccinations, population_density
From Covid_Project..CovidDeaths$
order by 1,2



--Total_Vaccinations Vs Population
--it shows the percentage of people getting vaccinated per population 
Select dea.continent, dea.location, dea.date, dea.total_vaccinations, wor.population, (dea.total_vaccinations/wor.population * 100) AS VaccinationsPopulatedPercentage
From Covid_Project..CovidDeaths$ dea
JOIN Covid_Project..covid_worldwide$ wor
	ON dea.location = wor.country
where dea.location is not null
Group by dea.continent, dea.location, dea.date, dea.total_vaccinations, wor.population
ORDER BY 1,2



--Total_Vaccinations Vs Population_density
--it shows the percentage of each countries getting vaccinations with their population_denity
Select continent, location, date, total_vaccinations, population_density, (total_vaccinations/population_density * 100) AS VaccinationsPopulatedByContinents
From Covid_Project..CovidDeaths$
where continent like '%AFRICA%'
ORDER BY 1,2



--Total Cases vs Total Deaths
Select Country, [Total Deaths], [Total Cases], ([Total Deaths]/[Total Cases] * 100) AS Percentagedeaths
From Covid_Project..covid_worldwide$
Where Country like '%US%'
order by 1,2



--Total Cases vs Population
Select Country, [Total Cases], Population, ([Total Cases]/Population * 100) AS Percentagepopulation
From Covid_Project..covid_worldwide$
--Where Country like '%US%'
order by 1,2



--Countries with the highest infection rate compared to population 
Select Country, MAX([Total Cases]) AS HighestInfectionCount, Population, MAX(([Total Cases]/Population * 100)) AS Percentagepopulation
From Covid_Project..covid_worldwide$
--Where Country like '%US%'
Group by Country, Population
order by Percentagepopulation desc



--Countries with the highest death count per population
Select Country, MAX(cast([Total Deaths] as int)) AS TotalDeathCount
From Covid_Project..covid_worldwide$
--Where Country like '%US%'
Group by Country
order by TotalDeathCount desc



--Global Numbers
Select Country, [Total Deaths], [Total Cases], ([Total Deaths]/[Total Cases] * 100) AS Percentagedeaths
From Covid_Project..covid_worldwide$
--Where Country like '%US%'
order by 1,2



--Total Population vs Vaccinations
Select dea.location, dea.date, wor.Population,dea.new_vaccinations
From Covid_Project..covid_worldwide$ wor
Join Covid_Project..CovidDeaths$ dea
	On wor.Country = dea.location
where dea.location is not null
Group by dea.location, dea.date, wor.Population,dea.new_vaccinations
order by 2,3



--Total Population VS Vaccinations
--Shows Percentage of Population that have received atleast one covid vaccine
Select dea.continent, dea.location, dea.date, wor.Population, dea.new_vaccinations, SUM(CAST(dea.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
From Covid_Project..covid_worldwide$ wor
Join Covid_Project..CovidDeaths$ dea
	On wor.Country = dea.location
where dea.location is not null
order by 2,3



----Getting Percentage of Total_Deaths AND Total_Cases
Select dea.location, dea.date, wor.Population, wor.[Total Deaths], wor.[Total Cases], (wor.[Total Deaths]/wor.[Total Cases] * 100) AS Percentagedeaths
From Covid_Project..covid_worldwide$ wor
Join Covid_Project..CovidDeaths$ dea
	On wor.Country = dea.location
where dea.location is not null
Group by dea.location, dea.date, wor.Population, wor.[Total Deaths], wor.[Total Cases]
Order by 2,3



--Getting the Percentage of  RollingPeopleVaccinatedPercentage
WITH PopvsVac (Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, wor.Population, dea.new_vaccinations, 
SUM(CAST(dea.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
From Covid_Project..covid_worldwide$ wor
Join Covid_Project..CovidDeaths$ dea
	On wor.Country = dea.location
where dea.location is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100 AS RollingPeopleVaccinatedPercentage
From PopvsVac