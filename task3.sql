sql Query :select a.username, i.type, ai.quality as advised_quality,string_agg(i.name, ', ' order by i.name asc) as advised_name
from accounts a
join  accounts_items ai on a.id = ai.account_id
join  items i on ai.item_id = i.id
where ai.quality = (
        select max(quality)
        from accounts_items ai_sub
        where ai_sub.account_id = a.id
          and i.type = (
              select type
              from items
              where items.id = ai_sub.item_id
          )
    )
group by a.username, i.type, ai.quality
order by a.username asc, i.type asc; 