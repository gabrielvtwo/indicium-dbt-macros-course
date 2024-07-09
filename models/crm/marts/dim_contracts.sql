with selection as (
    select *
    from {{ ref('stg_contracts') }}
)

select *
from selection