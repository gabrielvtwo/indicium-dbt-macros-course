{% macro execution_metadata_collector_reworked(results) %}

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
        },
        "job_id": {
            "datatype": "string"
            , "description": "This is the job for the execution."
        },
        "elapsed_time": {
            "datatype": "numeric"
            , "description": "This is the time it took for the node to run in seconds."
        },
        "inserted_at": {
            "datatype": "timestamp"
            , "description": "This is the timestamp on which the row has been inserted."
        }
    } %}

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

    {#- 
        Now begins the insertion part of the macro!
        We are going to insert data on the table based on the metadata collected.
    -#}

    {#- 
        First we set the timestamp in which this is running by using the isoformat()
        PS: This will be the inserted_at value!
    -#}
    {% set now = modules.datetime.datetime.now().isoformat() %}

    {#- We will set an empty list here -#}
    {% set values_to_insert = [] %}
    {#- Now we are going to iterate over the results list to fill the values we want -#}
    {% for res in results %}
        {#- 
            We are doing an append since values_to_insert is a list. 
            The output of what we want is something like this:
            
                ("first_value", "second_value", "third_value"...)
            
            This will be used inside a values() SQL statement soon.
        -#}
        {% do values_to_insert.append(
            "(" 
            ~ '"' ~ res.node.unique_id ~ '"' ~ ","
            ~ '"' ~ res.adapter_response.job_id ~ '"' ~ ","
            ~ res.execution_time ~ ","
            ~ '"' ~ now ~ '"'
            ~ ")"
        ) %}
        {#- 
            Note that the res.execution_time is a numeric return, so we won't add the "" quotes
            Also notice how we are dealing with the ~ each line, but the output won't have a newline
        -#}
    {% endfor %}

    {#- Now we will set the insert query -#}
    {#- 
        The for statement will iterate through every row of the values_to_insert list, which will
        populate the values() SQL statement with a valid SQL expression and the values required.

        DISCLAIMER: We are not dynamically setting the position of the values. So, in an event of
        changing the sequence of the variables or adding new variables to collect, we need to
        organize manually the sequence on the values_to_insert list.
    -#}
    {% set insert_metadata_table_query %}
        insert {{ collector_project }}.{{ collector_dataset }}.{{ collector_table }}
            (
                {% for key, value in metadata_to_collect.items() %}
                    {{ key }}{%- if not loop.last -%},{%- endif -%}
                {% endfor %}
            )
        values
        {%- for row in values_to_insert %}
            {{ row }}{%- if not loop.last -%},{%- endif -%}
        {%- endfor %}
    {% endset %}

    {#- Finally, let's run the insert query -#}
    {% do run_query(insert_metadata_table_query) %}

    {{ log("Metadata collected successfully! Data was inserted into the table " ~ metadata_relation, info=True) }}

{% endif %}

{% endmacro %}
