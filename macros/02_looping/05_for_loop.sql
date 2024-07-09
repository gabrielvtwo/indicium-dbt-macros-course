{% macro looping() %}

    -- Lets set a list
    {% set list = [
        "john doe"
        , "jane doe"
    ] %}

    -- Log it, so it will store it in the dbt.log file
    -- Also... with info=true, it will show in the terminal
    {% do log(list, info=true) %}

    -- Now let's loop through the list and print each item
    {% for item in list %}

        {% do log(item, info=true) %}
    
    {% endfor %}

{% endmacro %}
