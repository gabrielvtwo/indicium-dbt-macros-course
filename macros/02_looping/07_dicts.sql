{% macro dicts() %}

    -- Let's set a dict
    -- Check how we can expand with a lot of key/value pairs
    {% set dict = {
        "john doe": {
            "employed": false
            , "age": 30
        }
        , "jane doe": {
            "employed": true
            , "age": 29
        }
    } %}

    -- Looping through the dict
    {% for item in dict.values() %}
        {% do log(item.employed, info=true) %}
    {% endfor %}

{% endmacro %}
