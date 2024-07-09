{% macro selectattr_example() %}

    {% if execute %}

        -- Now we are using a jinja filter called selectattr to filter data from the graph
        {% for node in graph.nodes.values() 
            | selectattr("config.materialized", "equalto", "table") 
            | selectattr("resource_type", "equalto", "model") %}

            {% do log(node.name, info=true) %}

        {% endfor %}

    {% endif %}

{% endmacro %}
