Select * from layoffs;

create table LS like layoffs;
select * from LS;
insert ls select* from layoffs;

#DELETING DUPLICATES______________________________________________________________

--SET SQL_SAFE_UPDATES = 0;
select *, 
row_number() over(
partition by company, location, industry, total_laid_off, 
percentage_laid_off ,'date', stage, country, 			 #kyuki isme km col names the to kuch duplicates fir bhi aa rahe the...
funds_raised_millions
) As Row_num from LS;

with duplicate_cte as
(
select *, 
row_number() over(
partition by company, location,
 industry, total_laid_off, percentage_laid_off,'date', stage
 , country, funds_raised_millions) As Row_num 				
 from LS
)
Select * from duplicate_cte
where row_num > 1; 



select* from ls where company = 'hibob';


with duplicate_cte as
(
select *, 
row_number() over(
partition by company, location,
 industry, total_laid_off, percentage_laid_off,'date', stage
 , country, funds_raised_millions) As Row_num 
 from LS
)
Select * from duplicate_cte 
where row_num > 1;

DELETE FROM ls2 where row_num >1;

Select * from ls2;

#STANDARDIZING DATA_________________________________________________________________________

SELECT COMPANY, trim(COMPANY) FROM LS2;
UPDATE LS2 SET COMPANY=trim(COMPANY);

SELECT DISTINCT INDUSTRY FROM LS2 ORDER BY 1;
SELECT * FROM LS2 WHERE INDUSTRY LIKE 'CRYPTO%';
UPDATE ls2 SET INDUSTRY = 'Crypto' 
WHERE INDUSTRY like 'Crypt%';										#corrected the similar name error

select distinct location from ls2 order by 1;						#seems good- no repetetion- no extra spaces

select distinct Country from ls2 order by 1;		
select * from ls2 where country like 'united stat%';
UPDATE ls2 SET Country = 'United States' 
WHERE Country like 'United State%';	
select distinct Country from ls2 order by 1;						#corrected the similar name error by Traditional method OR what we can dfo is
																	# USE SELECT COUNTRY, trim( TRAILING '.' FROM COUNTRY) FROM LS2; # THEN UPDATE LS2
												
# CHANGING DATE COLUMN FORMAT FROM TEXT TO TIME AND DATE FORMAT_______________________________________

SELECT date,
str_to_date(date,'%m/%d/%Y')
from ls2;

UPDATE LS2
SET DATE=str_to_date(date,'%m/%d/%Y');

SELECT * FROM LS2; 		
					
ALTER TABLE LS2	Modify column 'DATE' Date;									# DATE FORMAT CORRECTED
									
#populating Null values___________________________________________________________________________________

Select * from LS2 where industry Is null or industry = '';   				 #checking if how many entries of industries are null

Select * from LS2 where company = 'Airbnb';

Select * from LS2 as t1 join ls2 as t2 
	on t1.company=t2.company and t1.location=t2.location 
	where (t1.industry is null or t1.industry='') and t2.industry is not null;
    
Update LS2 as t1 join ls2 as t2
	on t1.company=t2.company and t1.location=t2.location 
    Set t1.industry=t2.industry
    where (t1.industry is null or t1.industry='') and t2.industry is not null;       

# to check the changes
Select t1.industry, t2.industry from LS2 as t1 join ls2 as t2 
	on t1.company=t2.company and t1.location=t2.location 
	where (t1.industry is null or t1.industry='') and t2.industry is not null;		#still blank
    
Select * from LS2 where company = 'Airbnb';											#still blank because insted of null they are blanks

# setting blanks into nulls
update ls2 set industry=null where industry='';

# trying to update it again removing the blank '' statement from the query
Update LS2 as t1 join ls2 as t2
	on t1.company=t2.company and t1.location=t2.location 
    Set t1.industry=t2.industry
    where t1.industry is null and t2.industry is not null; 

Select * from LS2 where company like 'Bally%';  											# done populating


Select * from ls2
	where total_laid_off is null and percentage_laid_off is null;			# deleting them but if not confident make new table and perform it on that

create table LS3 like ls2;
select * from LS3;
insert ls3 select * from ls2;												# new table created

Select * from ls3
	where total_laid_off is null and percentage_laid_off is null;
    
Delete from ls3
	where total_laid_off is null and percentage_laid_off is null;
    
Select * from ls3;

# Drop row number column____________________________________________________________________________________

alter table ls3
drop column	row_num;

Select * from ls3;