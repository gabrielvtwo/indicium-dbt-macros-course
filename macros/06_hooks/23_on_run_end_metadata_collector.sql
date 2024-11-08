{% macro execution_metadata_collector(results) %}

{% if execute %}

    {#- Inputs we gotta collect to make our macro work -#}
    {#- First, we will set the database relation in which we want to save the metadata collected -#}
    {% set collector_project = target.project %}
    {% set collector_dataset = var("metadata_dataset") %}
    {% set collector_table = "dbt_models_metadata" %}

    {#- Now we are going to define a dictionary with the table schema -#}
    {% set metadata_to_collect = {
        "unique_id": {
            "datatype": "string"
            , "description": "This is the unique_id of the node."
            , "values": {}
        },
        "job_id": {
            "datatype": "string"
            , "description": "This is the job for the execution."
            , "values": {}
        },
        "elapsed_time": {
            "datatype": "numeric"
            , "description": "This is the time it took for the node to run in seconds."
            , "values": {}
        },
        "inserted_at": {
            "datatype": "timestamp"
            , "description": "This is the timestamp on which the row has been inserted."
            , "values": {}
        }
    } %}

    {{ log(metadata_to_collect, info=True) }}

    {#- Our macro will create the metadata table if it doesn't exist yet -#}

    {#- Let's first find out if the table exists -#}
    {%- set metadata_relation = adapter.get_relation(
        database = collector_project,
        schema = collector_dataset,
        identifier = collector_table) -%}

    {#- If the above adapter.get_relation doesn't find the table, it will run what it is inside the if statement -#}
    {% if metadata_relation is none %}
        {{ log("The " ~ collector_table ~ " doesn't exists. Let's create it!" , info=True) }}

        {% set create_metadata_table_query %}
            create table {{ collector_project }}.{{ collector_dataset }}.{{ collector_table }} (
            {% for key, value in metadata_to_collect.items() %}
                {{ key }} {{ value.datatype }} options (description = '{{ value.description }}'){%- if not loop.last -%},{%- endif -%}
            {% endfor %}
            ) 
            partition by timestamp_trunc(inserted_at, day)
            options (
                description = 'This is the metadata table for dbt which collects information on dbt executions.',
                partition_expiration_days = 90,
                require_partition_filter = true)
        {% endset %}

        {{ log(create_metadata_table_query, info=True) }}

        {% do run_query(create_metadata_table_query) %}
    {% endif %}

    {% set insert_metadata_table_query %}
        insert {{ collector_project }}.{{ collector_dataset }}.{{ collector_table }}
            (
                {% for key, value in metadata_to_collect.items() %}
                    {{ key }}{%- if not loop.last -%},{%- endif -%}
                {% endfor %}
            )
        values
        {% for res in results %}
            (
            {% for key, value in metadata_to_collect.items() %}
                {{ value.graph_path }}{%- if not loop.last -%},{%- endif -%}
            {% endfor %}
            ){%- if not loop.last -%},{%- endif -%}
        {% endfor %}
    {% endset %}

    {{ log(insert_metadata_table_query, info=True) }}

{% endif %}

{% endmacro %}
