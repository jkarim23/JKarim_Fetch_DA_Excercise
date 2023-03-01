/* 
Utilizing SQL Standard ANSI
--Questions to answer:
	--Which brand has the most spend among users who were created within the past 6 months?
	--Which brand has the most transactions among users who were created within the past 6 months?

Description: Utilizing user data, use this query to analyze the brand with the most spend or change
	commenting on the ORDER BY conditions lines 54 and 55 to analyze the brand with the most transactions within the past 6 months.
        The brand on the first row of the results will be the brand with the most for either condition.
	In my query I assumed that we did not want to include data from fetch staff as they can likely be skewed with testing are considered biased.
	I also did not include inactive users as they are likely inactive due to reasonable causes like fraud, etc.

*/

with users_group as ( -- target active users that have been created in the last 6 months
	
    select 
    	user_id,
    	active,
        role,
        createdDate
    from 
    	users
    where 
    	active = TRUE -- target active scanners
    	and role = 'CONSUMER' --remove fetch-staff role to prevent bias and testing from skewing data
    	and createdDate >= DATEADD(MONTH, -6, GETDATE()) -- users who have been created within the past 6 months
), users_receipts as ( --target receipts scanned from qualifying users_group

    select
        brand_id,
        finalPrice,
        receipt_id
    from 
    	users_group
    left join  -- show receipts from users that qualify the users_group conditions
    	rewards_receipt_item_list
    on 
    	usersgroup.user_id = receipts.user_id
    where 
    	receipts.rewardsReceiptStatus = 'FINISHED' -- look at processed and acceptable receipts
), 
--time to aggregate brand findings
select 
    brands.name as brand_name,
    sum(users_receipts.finalPrice) as spend_on_brand,
    count(distinct users_receipts.receipts_id) as transactions_per_brand
from
    users_receipts
inner join -- show brands that we have product and brand information about
    brands
on 
    users_receipts.brand_id = brands.brand_id
group by 
    1
order by spend_on_brand desc -- to view brand with the most transactions, comment this line out and remove the comments at the beginning of the line below
--order by transactions_per_brand desc -- to view brand with the most spend, comment this line out and remove the comments on the code in the line above 
;
