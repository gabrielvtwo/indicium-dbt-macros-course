{% macro more_complex_dicts() %}

    -- Let's set a dict
    -- Check how we can expand with a lot of key/value pairs
    {% set dict = {
        "john doe": {
            "tags": ["01", "02"]
            , "age": 30
        }
        , "jane doe": {
            "tags": ["01", "03", "04"]
            , "age": 29
        }
    } %}

    -- Look how we are printing a specific key from the dict, specifically the first tag
    {% for item in dict.values() %}
        {% do log(item.tags[0], info=true) %}
    {% endfor %}

{% endmacro %}
