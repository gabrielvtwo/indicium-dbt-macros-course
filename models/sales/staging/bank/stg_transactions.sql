with source as (
    select *
    from {{ source('trusted_bank', 'transactions') }}
)

, renamed as (
    select
        transactionid as transaction_id
        , user as transaction_user
        , transdate as transaction_date
        , value as transaction_value
        , var001 as var_001
        , var002 as var_002
        , var003 as var_003 
        , var004 as var_004 
        , var005 as var_005 
        , var006 as var_006 
        , var007 as var_007 
    from source
)

select *
from renamed
