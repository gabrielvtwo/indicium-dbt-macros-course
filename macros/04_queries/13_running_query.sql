{% macro running_query() %}

    -- We set a query as a multiline string
    {% set query %}

        select *
        from indicium-sandbox.dev_gabriel.dim_customers
        -- Look! A query!

    {% endset %}

    -- Now we are running the query with the run_query statement
    {% do run_query(query) %}

    /*
        Depending on your warehouse, go check the jobs in it to see if your query had a successful run
        Notice that nothing will be printed in the terminal, but something happens
        Try to experiment with the run_query, assigning it to a variable
        dbt jinja documentation has good resource on run_query as well
    */

{% endmacro %}
