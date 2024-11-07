with staging as (
    select *
    from {{ source('trusted_northwind', 'contracts') }}
)

select *
from staging
