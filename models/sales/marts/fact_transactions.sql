with transactions as (
    select *
    from {{ ref('stg_transactions') }}
)

, new_features as (
    select
        *
        , case
            when transaction_value < 0
                then 'outcome'
            when transaction_value >= 0
                then 'income'
        end as transaction_type
        , split(transaction_user, "@")[OFFSET(1)] as transaction_domain
    from transactions
)

, final as (
    select
        {{ dbt_utils.generate_surrogate_key(["transaction_id"]) }} as transaction_sk
        , transaction_user
        , transaction_date
        , transaction_type
        , transaction_domain
        , transaction_value

        -- metrics
        , var_001
        , var_002
        , var_003
        , var_004
        , var_005
        , var_006
        , var_007
    from new_features
)

select *
from final