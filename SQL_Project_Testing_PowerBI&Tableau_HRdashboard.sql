/****** Script for SelectTopNRows command from SSMS  ******/
select *
From hrdata

--Testing sum of Employee Count as well as sum of employee count as per education filter

select SUM(Employee_count) as sum from hrdata 
where education='High school'

--Testing sum of employee count by department

Select SUM(Employee_Count) as sum from hrdata
Where department='Sales'

Select SUM(Employee_Count) as sum from hrdata
Where department='R&D'

--Testing sum of employee count by education field

Select sum(Employee_count) as sum from hrdata
where education_field='Medical'

--Testing attrition count

select count(attrition) as count_of_attrition from hrdata
where attrition='yes' and education='doctoral degree'

select count(attrition) as count_of_attrition from hrdata
where attrition='yes' and department='R&D' and education_field='medical' 
and education='high school'

--Testing attrition rate

select round(((select count(attrition) as count_of_attrition from hrdata where attrition='yes')/
sum(employee_count))*100, 2) as attrition_rate from hrdata

select round(((select count(attrition) as count_of_attrition from hrdata where attrition='yes' and department='sales')/
sum(employee_count))*100, 2) as attrition_rate from hrdata
where department='sales'

--Testing Active employee


select sum(employee_count)-(select COUNT(attrition) from hrdata where attrition='Yes') as Active_Employee
From hrdata 

select sum(employee_count)-(select COUNT(attrition) from hrdata where attrition='Yes' and gender='male') as Active_Male_Employee
From hrdata where gender='Male'

--Testing Average Age

select round(avg(age), 0) as Avg_age
From hrdata

--Testing attrition by gender

Select gender,Count(attrition) as gender_attrition_rate from hrdata 
where attrition='yes'
Group by gender
Order by Count(attrition) desc

Select gender,Count(attrition) as gender_attrition_rate from hrdata 
where attrition='yes' and education='High School'
Group by gender
Order by Count(attrition) desc

--testing department wise attrition in pie chart(%)

select Department,count(attrition) as Department_wise_attrition from hrdata
where attrition='yes'
group by Department

select Department,
round((cast(count(attrition) as numeric)/(select count(attrition) as Department_wise_attrition from hrdata where attrition='yes'))*100, 2) as percentage_attrition_rate
from hrdata
where attrition='yes'
group by Department

select Department,
round((cast(count(attrition) as numeric)/(select count(attrition) as Department_wise_attrition from hrdata where attrition='yes' and gender='Female'))*100, 2) as percentage_attrition_rate
from hrdata
where attrition='yes' and gender='Female'
group by Department
Order by Count(attrition) desc

--testing number of employees by age group (bar chart)

select age, sum(employee_count) as agewise_employeecount
from hrdata
group by age
order by age desc

select age, sum(employee_count) as agewise_employeecount
from hrdata
where department='R&D'
group by age
order by age desc

--Testing Educataion field wise attrition

select Education_field, count(attrition) as education_fieldwise_attrition
From hrdata
where attrition='Yes'
Group by education_field
Order by education_fieldwise_attrition asc

--Testing attrition by gender for different age group

select age_band, gender, COUNT(attrition) as age_gender_wise_attrition
From hrdata
where attrition='yes'
group by age_band, gender
order by age_band, gender

select age_band, gender, COUNT(attrition) as age_gender_wise_attrition,
round(CAST(count(attrition) as numeric)/(select count(attrition) from hrdata where attrition='yes')*100, 2) as prcntge_ageandgenderwise_attrition
From hrdata
where attrition='yes'
group by age_band, gender
order by age_band, gender

--Testing job satisfaction ratings table

Create Extension if not exists tablefunc;

select*
From crosstab(
'select job_role, job_satisfaction, sum(employee_count)
from hrdata
Group by job_role, job_satisfaction
order by job_role, job_satisfaction'
) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
Order by job_role;

--Testing number of employee by age group and gender

select age_band,gender,SUM(employee_count) as sum_of_employeecount
From hrdata
group by age_band, gender














