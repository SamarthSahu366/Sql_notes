with recursive cte as (select image_id, score, row_number() over (order by score desc) as rn from unlabeled_image_predictions),
high_quality as (select * from cte where score >= 0.5 and rn % 3 = 0
),
low_quality as (
    select image_id, score, rn from cte where rn = (select max(rn) from cte) -- start from the last row
    union all
    -- recursive part
    select c.image_id, c.score, c.rn from cte c join low_quality lq on c.rn = lq.rn - 3 where c.score < 0.5
)
select * from high_quality union all select * from low_quality;


