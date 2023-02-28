/*
Utilizing SQL Standard ANSI
In order to solve multiple analyses, the data in each table must be complete, especially when analyzing user data like demographics or user history as well as when 
we share our analysis with partners, we need to make sure that brand data is comprehensive and accurate. To combat this, we need to make sure that each field is filled out.
*/

--This query analyzes any null values in the USER table that are missing that we need to keep in mind when creating analyses around these fields.
select 
	*
from
	users
where 
	(
    user_id is null 
    or active is null
    or role is null
    or creadtedDate is null
    or lastLogin is null
    or signUpSource is null
    or state is null
    )
;
/* I have found missing data pertaining to our users and their activity including their last login date with the assumption that they had to login when 
they created an account and a handful of consumer-role accounts and many fetch-staff-role accounts are missing state data from their user profiles.
*/

--This query is used to identify SPD OCR from receipts that are not assigned a brand_id because we do not have information about what the OCR.
select 
    item_list.original_item_text,
	count(item_list.original_item_text)
from
    rewards_receipt_item_list as item_list
where
	brand_id is null
group by 1
order by item_list.original_item_text desc
/* 
I have found instances where we do not have brand information on SPD OCR for which will skew our data for brands with the most spend 
and most transactions. With the query we can view the most freqntly seen SPD OCR we have not assigned a brand_id.
/*
