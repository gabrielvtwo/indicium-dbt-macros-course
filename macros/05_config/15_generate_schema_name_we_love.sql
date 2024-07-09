{% macro generate_schema_name_we_love(custom_schema_name, node) -%}

    /* 
        This is the macro that we generally go for in our projects at Indicium
        What it will do is that it will see what target.name from the profile is running dbt

        If the target is for example "dev", it means that a developer is running dbt locally
        and we would like to place all of his development models in a single schema such as 
        dbt_gbernardo

        But if the target is prod, in this simple example it will be the "else" and then
        we will write the data to the destined schema configured in dbt_project.yml, because
        that way it is easier to organize schemas without the confusing concatenation of dbt
        original generate_schema_name

        We could go further here and, for example, define a schema also for CI
        Or even have a difference between schemas from homolog and prod
    */

    {%- set default_schema = target.schema -%}
    {%- if target.name == 'dev' -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}