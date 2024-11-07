{% set variables = ["var_001", "var_002", "var_003", "var_004", "var_005", "var_006", "var_007"] %}

{% set metrics_layout = {
        "var_001": {
            "metrics": ["min", "max"]
        }
        , "var_002": {
            "metrics": ["min", "max"]
        }
        , "var_003": {
            "metrics": ["min", "max", "avg"]
        }
        , "var_004": {
            "metrics": ["min", "max", "avg"]
        }
        , "var_005": {
            "metrics": ["min", "max", "avg", "stddev"]
        }
        , "var_006": {
            "metrics": ["sum"]
        }
        , "var_007": {
            "metrics": ["sum"]
        }
}
%}

{% set final_columns = [] %}

with fact_transactions as (
    select *
    from {{ ref('fact_transactions') }}
)

, calculating_metrics as (
    select
        {%- for variable, metrics in metrics_layout.items() -%}
            {% for metric in metrics.metrics %}
                {{ metric }}({{ variable }}) as {{ variable }}_{{ metric }}
                {%- do final_columns.append(variable ~ "_" ~ metric) -%}
            {%- if not loop.last -%},{%- endif -%} {%- endfor -%} {%- if not loop.last -%},{%- endif -%}
        {%- endfor %}
    from fact_transactions
)

, unpivoting as (
    {% for column in final_columns %}
        select
            "{{ column }}"  as metric
            , {{ column }} as value
        from calculating_metrics
        {% if not loop.last -%}union all{%- endif -%}
    {% endfor %}
)

select *
from unpivoting
