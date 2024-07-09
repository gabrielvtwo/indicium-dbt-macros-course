{% macro graph_example() %}

    -- We use 'if execute' to guarantee that dbt will run this macro in execute mode
    
    {% if execute %}
        -- Which means that here inside the if, graph.nodes dict will be entirely filled because compilation has ended

        -- We iterate through the graph like this
        {% for node in graph.nodes.values() %}
            -- To check how we can access data from graph, go see the manifest.json
            {% do log(node.name, info=true) %}
        {% endfor %}

    {% endif %}

{% endmacro %}