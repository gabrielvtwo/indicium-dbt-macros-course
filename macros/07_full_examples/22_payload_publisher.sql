{% macro payload_publisher() %}

    {#-
        This is an example of how we can use macros to perform more architectural designs.

        In this example, we are making dbt part of a pubsub publisher architecture.
        For more information on pubsub and what it does, check this documentation:
        https://cloud.google.com/pubsub/docs/overview?hl=pt-br

        For this example, we want to provide some information at the end of each
        dbt model execution as a post hook with informations that we can get from
        graph.nodes.

        Imagine that dbt needs to provide information such as execution time,
        who is the owner of each table and the location of the table in the
        Data Warehouse.

        So we will loop through the graph.nodes to get these information and save it to
        a payload, which is the message pubsub will replicate later.
        
        This message will have a JSON format, to facilitate parsing later.

        After we acquire the information, we will export it to GCS by using 
        BigQuery native export support with a SQL query.

        A lot of nice stuff is happening here, so check the comments and try to
        make sense of the code logic.
    -#}


    {% if execute %}
    {#- First we set the date for now, by using the datetime python module. -#}
    {% set now = modules.datetime.datetime.now().strftime("%d%m%Y_%H%M%S") %}
        {#- We are looping through items in graph.nodes -#}
        {% for node in graph.nodes.values() -%}
            {#- We are filtering for the node in the context of post hook, which is 'this' -#}
            {%- if node.name == this.name -%}
                {#-
                    We are setting the payload
                    Notice that we are using replace() jinja filter to deal with Undefined
                -#}
                {% set payload = {
                    this.name: {
                        'owner': node.meta.owner | replace('Undefined', 'null')
                        , 'identifier': this.database ~ '.' ~ this.schema ~ '.' ~ this.identifier
                    }
                } %}
                {#-
                    Now we are calling a export_to_gcs macro that is defined below.
                    Check how we are using a var from dbt_project.yml to set the bucket
                    Go to dbt_projecy.yml to see how this was defined.
                -#}
                {% do export_to_gcs(
                    export_data = payload[this.name]
                    , bucket = var('payload_bucket')
                    , datetime = now
                    , name = this.name
                ) %}
            {%- endif -%}
        {%- endfor %}
    {%- endif -%}

{% endmacro %}

{#- This is the other macro, for exporting to GCS. -#}
{% macro export_to_gcs(export_data, bucket, datetime, name) %}
    {#-
        This is a good showcase of the functional aspect of jinja in dbt.
        Notice how we are making two functions, and calling one inside the other.
    -#}

    {% if execute %}

        {#-
            This will set the export query
            Notice how we are using variables to fill the gaps
        -#}
        {% set export %}

            export data
            options (
                uri = 'gs://{{ bucket }}/dbt_payload_{{ name }}_{{ datetime }}_*.json'
                , format = 'JSON'
                , overwrite = true
            ) as (
                select
                    "{{ export_data.owner }}" as owner
                    , "{{ export_data.identifier }}" as identifier
            )

        {% endset %}

        {#- We run the export query -#}
        {% do run_query(export) %}

        {#- And log it! -#}
        {% do log("Payload for " ~ this.name ~ " exported to GCS!") %}

    {%- endif -%}

{% endmacro %}