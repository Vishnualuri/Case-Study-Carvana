--Table Creation 

CREATE TABLE recon_dates(
    Vehicle_ID INTEGER,
    Recon_Week DATE,
    PRIMARY KEY(Vehicle_ID));

CREATE TABLE recon_work(
    Vehicle_ID INTEGER,
    Total_Recon_Cost REAL,
    PRIMARY KEY(Vehicle_ID));
	
CREATE TABLE stock_details(
    Vehicle_ID INTEGER,
    Year INTEGER,
    Make TEXT,
    Model TEXT,
    TrimLine TEXT,
    BodyStyle TEXT,
    InteriorColor TEXT,
    ExteriorColor TEXT,
    Doors INTEGER,
    OdometerValue REAL,
    AcquisitionDate DATE,
    AcquisitionSource TEXT,
    PRIMARY KEY(Vehicle_ID));
	
	
--Analysis

select A.Recon_Week, avg(A.Total_Recon_Cost) as avg_price_per_make, avg(OdometerValue) as avg_odo, count(A.Vehicle_ID) as Num_vehicles from 
 (
 select * from stock_details 
 join recon_work
 on stock_details.Vehicle_ID = recon_work.Vehicle_ID
 join recon_dates
 on recon_dates.Vehicle_ID = recon_work.Vehicle_ID
 )A
 group by 1
 order by A.Recon_Week desc
 
--
 
 select A.Recon_Week, A.Make, avg(A.Total_Recon_Cost) as avg_price_per_week, avg(OdometerValue) as avg_odo, count(A.Vehicle_ID) as Num_vehicles from (
	 select * from stock_details 
	 join recon_work
	 on stock_details.Vehicle_ID = recon_work.Vehicle_ID
	 join recon_dates
	 on recon_dates.Vehicle_ID = recon_work.Vehicle_ID
	 )A
	 group by 1,2
	 order by A.Recon_Week desc

--
	 
select stock_details.BodyStyle,sum(recon_work.Total_Recon_Cost) as totalcost, avg(recon_work.Total_Recon_Cost) as avgcost , count(recon_dates.Vehicle_ID) as numofvehicles from recon_work
join stock_details
on recon_work.Vehicle_ID = stock_details.Vehicle_ID
join recon_dates 
on recon_work.Vehicle_ID = recon_dates.Vehicle_ID
group by stock_details.BodyStyle

--

select rd.Recon_Week, sum(rw.Total_Recon_Cost) as sum_of_total_recon_cost, count(rw.Vehicle_ID) as no_of_vehicles_sold
from recon_dates rd
join recon_work rw 
on rd.Vehicle_ID = rw.Vehicle_ID
group by rd.Recon_Week 


--

select A.*,
case when A.Recon_Week != '2020-07-27 00:00:00' and A.Recon_Week != '2020-08-17 00:00:00' then 'recon_cost_for_other_weeks'
	 else A.Recon_Week end as flag
from (
select rd.Recon_Week, sd.BodyStyle, rw.Total_Recon_Cost
from recon_dates rd
join recon_work rw 
on rd.Vehicle_ID = rw.Vehicle_ID
join stock_details sd
on sd.Vehicle_ID = rw.Vehicle_ID
where sd.BodyStyle = 'SUV'
order by rd.Recon_Week
)A

--

select A.*,
case when A.Recon_Week != '2020-07-27 00:00:00' then 'recon_cost_for_other_weeks_sedan'
	 else A.Recon_Week end as flag
from (
select rd.Recon_Week, sd.BodyStyle, rw.Total_Recon_Cost
from recon_dates rd
join recon_work rw 
on rd.Vehicle_ID = rw.Vehicle_ID
join stock_details sd
on sd.Vehicle_ID = rw.Vehicle_ID
where sd.BodyStyle = 'Sedan' 
order by rd.Recon_Week
)A


--

select rd.Recon_Week, avg(rw.Total_Recon_Cost) as avg_total_reconf_cost, avg(sd.OdometerValue) as avg_odometer_reading
from recon_work rw
join recon_dates rd
on rd.Vehicle_ID = rw.Vehicle_ID
join stock_details sd 
on rw.Vehicle_ID = sd.Vehicle_ID
group by rd.Recon_Week
order by rd.Recon_Week asc

--

select A.*, sum(A.no_of_vehicles_sold) over(PARTITION by A.Recon_Week) as weekly_sales
from (
select rd.Recon_Week, sd.BodyStyle, sum(rw.Total_Recon_Cost) as sum_of_total_recon_cost, count(rw.Vehicle_ID) as no_of_vehicles_sold
from recon_dates rd
join recon_work rw 
on rd.Vehicle_ID = rw.Vehicle_ID
join stock_details sd
on sd.Vehicle_ID = rw.Vehicle_ID
group by rd.Recon_Week, sd.BodyStyle 
order by rd.Recon_Week
)A

--
