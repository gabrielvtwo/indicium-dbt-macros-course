{% macro log_results(results) %}

    /* 
        This is an example provided by dbt in the on-run-end context page.
        Notice that this macro is receiving information from a results context
        as argument. We are accessing this results to extract information from it.

        The results dictionary is basically the run_results.json file, check it out!

        This information is only accessible in the on-run-end context, because it needs
        to have dbt execution as ended to generate results.

        Check dbt_project.yml on-run-end to see how we call this macro.
    */

    {% if execute %}
        {{ log("========== Begin Summary ==========", info=True) }}
        -- So for each result in the run_results.json
        {% for res in results -%}
            -- We are printing a summary
            {% set summary -%}
                - node: {{ res.node.unique_id }}
                - status: {{ res.status }}
                - message: {{ res.message }}
            {%- endset %}

            {{ log(summary, info=True) }}
        {% endfor %}
        {{ log("========== End Summary ==========", info=True) }}
    
    -- Ignore this part below!
    -- As we added comments, bigquery requires a query somehow.
    select 1 = 1

    {% endif %}

{% endmacro %}
