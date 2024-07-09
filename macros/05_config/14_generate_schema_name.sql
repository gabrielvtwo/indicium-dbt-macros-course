/*
    This is how dbt handle schema name as default
    A brief explanation:
    If the custom_schema_name (i.e, the schema we put in dbt_project.yml) is none
    Then we set the schema as the profile schema, known as default_schema
    But if there is, we will concat the default_schema with the custom_schema_name
*/

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}