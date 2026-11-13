select *
from PorfolioProject..CovidDeaths
where continent is not null
order by 3,4


--select *
--from PorfolioProject..CovidVaccination
--order by 3,4

-- select data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PorfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- looking at Total Cases vs Total Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2

-- looking at total cases vs population
-- shows what percentage got covid

select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

-- Lookin at Countries with HIGHTEST Infection Rate compared to Population

select Location, population, MAX(total_cases) as hightestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
from PorfolioProject..CovidDeaths
--where location like '%states%'
group by Location, Population
order by PercentagePopulationInfected desc

-- Showing Countries with Hightest Death Count per Population


select Location, MAX(cast (total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by Location
order by TotalDeathCount desc

select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Showing the continet with the hightest death count per population

select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- GLOBAL Numbers

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--Looking at total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

	-- USE CTE

	with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
	as 
	(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	)
	select *, (RollingPeopleVaccinated/population)*100
	from PopvsVac

	--temp table

	drop table if exists #PercentPopulationVaccinated
	create table #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	Location nvarchar (255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric 
	)
	insert into #PercentPopulationVaccinated

		select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	
	select *, (RollingPeopleVaccinated/population)*100
	from #PercentPopulationVaccinated

	--Creating VIEW to store data later vizualization

	Create View PercentPopulationVaccinated 
	as 	
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

	
	
	select *
	from PercentPopulationVaccinated