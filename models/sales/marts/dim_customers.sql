with selection as (
    select *
    from {{ ref('stg_customers') }}
)

select *
from selection