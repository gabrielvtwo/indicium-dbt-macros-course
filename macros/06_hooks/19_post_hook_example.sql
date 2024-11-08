{% macro post_hook_example() %}

    /* 
        This is a very simple example of a macro being called by the post hook context.
        Notice how we are using the "this" context from dbt, that it is only available
        when a dbt node is executing, which is the case for post hooks.

        Check dbt_project.yml post-hook to see how we call this macro.
    */

    {% if execute %}
        {% do log(this.name, info=true) %}

        -- Ignore this part below!
        -- As we added comments, bigquery requires a query somehow.
        select 1 = 1
    {% endif %}

{% endmacro %}