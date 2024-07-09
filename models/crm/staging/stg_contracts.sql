with staging as (
    select *
    from {{ source('trusted_dbcor', 'contracts') }}
)

select *
from staging
