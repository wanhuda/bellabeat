--to see how much calories are burn depending on a user activity
select*
from bellabeat.dbo.dailyActivity_merged

---TO SEE RELATIONS BETWEEN DIFFERENT VARIABLES WITH AMOUNTOF CALORIES BURN
--1. to see relationship btwn total steps and calories burn
select id,
	sum(TotalSteps) as total_steps,
	sum(Calories) as calories
from bellabeat.dbo.dailyActivity_merged
group by id
order by id

--2. to see relationship btwn activity distance and calories burn
select id, 
	sum(VeryActiveDistance) as VeryActiveDistance, 
	sum(ModeratelyActiveDistance) as ModeratelyActiveDistance, 
	sum(LightActiveDistance) as LightActiveDistance, 
	sum(SedentaryActiveDistance) as SedentaryActiveDistance, 
	sum(Calories) as Calories
from bellabeat.dbo.dailyActivity_merged
group by id
order by id

--3. to see relationship btwn activity minutes and calories burn
select id, 
	sum(VeryActiveMinutes) as VeryActiveMinutes, 
	sum(FairlyActiveMinutes) as FairlyActiveMinutes, 
	sum(LightlyActiveMinutes) as LightActiveMinutes, 
	sum(SedentaryMinutes) as SedentaryMinutes, 
	sum(Calories) as Calories
from bellabeat.dbo.dailyActivity_merged
group by id
order by id

--TO SEE HOW LONG ACTIVITIES PER DAY WERE RECORDED BY EACH USER
--1. FOr Recorded user activity
--create table from existing table
select id,
	VeryActiveMinutes,
	FairlyActiveMinutes,
	LightlyActiveMinutes,
	SedentaryMinutes,
	Calories
into bellabeat.dbo.cleanedDailyActivity
from bellabeat.dbo.dailyActivity_merged

--TO SEE ACTIVITY OF USERS
select id, 
	MostActiveHour,
	FairActiveHour,
	LightActiveHour,
	SedHour,
	Calory,
	(MostActiveHour+FairActiveHour+LightActiveHour+SedHour)/24.0 as Daysrecorded
from (
	select
		id,
		sum(VeryActiveMinutes/60.0) as MostActiveHour, 
		sum(FairlyActiveMinutes/60.0) as FairActiveHour, 
		sum(LightlyActiveMinutes/60.0) as LightActiveHour, 
		sum(SedentaryMinutes/60.0) as SedHour,
		sum(Calories) as Calory
	from bellabeat.dbo.cleanedDailyActivity
	group by id
) as activity_summary
order by id;

--2. For recorded user sleeping hour 
select 
	Id,
	sum(TotalMinutesAsleep/60.0) as TotalHourSleep
into bellabeat.dbo.sleeprecorded
from bellabeat.dbo.sleep_day
group by id

--to see sleeping days recorded
select
	id,
	TotalHourSleep/24.0 as DaySleepRecorded
from bellabeat.dbo.sleeprecorded
order by id
--this shows that some user does not record their sleep usingbelllabeat
--looking from all the relationships at point no 1,2 & 3, the number of id is lesser. shows that some user did not input their sleeping hour

--3. TO SEE HOW MANY AND HOW OFTEN USER INPUT THEIR WEIGHT INFO INTO BELLABEAT
--new table
select
	id,
	Date,
	WeightKg,
	BMI
into NewWeightInfo
from bellabeat.dbo.weightLogInfo

--to change datatype
select*
from NewWeightInfo
exec sp_help 'NewWeightInfo';
alter table NewWeightInfo alter column WeightKg float
GO
alter table NewWeightInfo alter column BMI float
GO

--Analysis for userweight log info	
select
	distinct id as id,
	count(id) as id_recorded,
	AVG (WeightKg) as weight,
	AVG (BMI) as newBMI
from NewWeightInfo
group by id
order by id
	