{% macro lists() %}

    -- Let's set two lists
    {% set list = [
        "john doe"
        , "jane doe"
    ] %}

    {% set other_list = [
        "john doe"
        , "jane doe"
    ] %}

    -- Let's check our lists with log()

    {% do log(list, info=true) %}
    {% do log(other_list, info=true) %}

    -- And now we are looping throgh ieach item of the first list
    {% for item in list %}

        {% do log(item, info=true) %}
    
    {% endfor %}

{% endmacro %}
