with stg_payments as (
    select *
    from {{ ref('stg_payments') }}
)

, transform as (
    select
        payment_id
        , {{ cents_to_dollars("amount") }} as amount_usd
    from stg_payments
)

select *
from transform
