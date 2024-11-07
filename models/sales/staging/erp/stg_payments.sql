with staging as (
    select
        "0001" as payment_id
        , 505 as amount
    union all
    select
        "0002" as payment_id
        , 1349 as amount
    union all
    select
        "0003" as payment_id
        , 99 as amount
)

select *
from staging