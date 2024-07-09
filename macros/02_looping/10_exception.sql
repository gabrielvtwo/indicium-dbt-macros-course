{% macro exception() %}

    -- Let's set a dict
    {% set dict = {
        "john doe": {
            "employed": false
            , "age": 30
        }
        , "jane doe": {
            "employed": true
            , "age": 29
        }
        , "mary jane": {
            "employed": true
            , "age": 33
        }
    } %}

    -- Let's set a list
    {% set list = [
        "john doe"
        , "jane doe"
    ] %}

    -- If any item of the dict is not in the list, we will raise a exception
    -- This is great to manage errors we want to throw, for example in a CI
    {% for key, value in dict.items() %}
        {% if key not in list %}
            {% do exceptions.raise_compiler_error(
                '
                There was an error!

                The person ' ~ key ~ ' is not in the list.
                '
            ) %}
        {% endif %}
    {% endfor %} 


{% endmacro %}
