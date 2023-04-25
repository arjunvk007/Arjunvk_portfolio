select *
from SQLPortfolioProjectDataExploration..CovidDeaths
order by 3,4

--select *
--from SQLPortfolioProjectDataExploration..CovidVaccination
--order by 3,4

--select the data that we are going to be using

select Location, Date, total_cases, new_cases, total_deaths, population
From SQLPortfolioProjectDataExploration..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
From CovidDeaths
where location like '%India%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid  

Select Location, Date, total_cases, population, (total_cases/population)*100 as percentage_of_population_got_COVID
From CovidDeaths
where location like '%India%'
order by 1,2 --(By 30/04/2021 1.38 percentage of Indian population got Covid/tested posititve)

--Looking at countries with highest infection rate compared to population
--Maximum number of population that got covid in each country

Select Location, population, max(total_cases) as Highestinfectioncount, (MAX(Total_Cases)/population)*100 as percentagepopulation_infected
From CovidDeaths
Group by location, population
Order by percentagepopulation_infected desc

--Countries showing highest death counts per population

Select Location, max(cast(total_deaths as int)) as totaldeathcount
From CovidDeaths
Group by location
Order by totaldeathcount desc

--Continents with highest death count per population

Select location, max(cast(total_deaths as int)) as totaldeathcount
From CovidDeaths
Where continent is null
Group by location
Order by totaldeathcount desc

--Calculating everything in entire world
--Global Numbers (Total cases, Total new deaths, Percentage of deaths)

Select Sum(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_deaths, (SUM(cast(new_deaths as int))/Sum(new_cases))*100 as percentage_of_deaths
From CovidDeaths
where continent is not null
order by 1,2

--Joining 2 tables
--Looking at total population vs vaccination (Looking at total people being vaccinated in the world)

With Popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as -- Created a CTE because we cannot use the same coloumn that we created in the same query
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
From CovidDeaths dea
Join CovidVaccination vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
select *, (rolling_people_vaccinated/population)*100 as total_vaccinated
From Popvsvac

--with temp table

Drop Table if exists #percentagepopulationvaccinated
Create table #percentagepopulationvaccinated
( Continent nvarchar(255), location nvarchar(255), Date datetime, Population numeric, New_vaccinations numeric, rolling_people_vaccinated numeric)

insert into #percentagepopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
From CovidDeaths dea
Join CovidVaccination vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select *, (rolling_people_vaccinated/population)*100 as total_vaccinated
From  #percentagepopulationvaccinated

--Create view to store data for later visualisations

Create view percentagepopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
From CovidDeaths dea
Join CovidVaccination vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

Create view popvsvac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
From CovidDeaths dea
Join CovidVaccination vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null










