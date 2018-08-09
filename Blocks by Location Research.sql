with
block_in as 
(select 
util.log_id, 
PERFORM_PROCEDURE_IN,
case when perform_procedure_out is null then 0 else PERFORM_PROCEDURE_OUT end as "Performed Out",
case when perform_cleanup_out is null then 0 else perform_cleanup_out end as "Cleanup Out",
case when perform_cleanup_in is null then 0 else perform_cleanup_in end as "Cleanup In",
case when PERFORM_SETUP_IN is null then 0 else perform_setup_in end as "Setup In",
case when PERFORM_SETUP_OUT is null then 0 else perform_setup_out end as "Setup Out"
from
OR_UTIL_BLOCK_CASE_SUM util
where
util.PERFORM_PROCEDURE_IN >= 1
and util_date < '2018-07-27'),

Block_sum as
(Select 
block_in.log_id,
Sum (PERFORM_PROCEDURE_In + "Performed Out" + "Cleanup Out" + "Cleanup In" + [Setup In] + [Setup Out]) as In_Block_time,
orl.loc_id, 
loc.loc_name
from
block_in
inner join
or_log  orl
on  
block_in.log_id = orl.log_id
inner join 
CLARITY_LOC loc
on
loc.loc_id = orl.loc_id
where
surgery_date >= '2018-06-04'
and
surgery_date <= '2018-06-11'
and
(orl.loc_id <> '1001991'
or 
orl.loc_id <> '1001997')
group by block_in.log_id, orl.loc_id , loc.loc_name)



Select 
Loc_name,
sum (in_block_time)
from Block_sum
group by Loc_name 
order by sum (in_block_time) desc

--select *
--from
--clarity_loc
--where
--LOC_ID = '1001991' 
--or LOC_ID = '1001997' 

--select *
--from
--or_log 
--where
--LOC_ID = '1001991' 
--or LOC_ID = '1001997' 
