{% macro if_loop() %}

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

    -- And a list
    {% set list = [
        "john doe"
        , "jane doe"
    ] %}

    -- In this for loop, we are accessing the dict.items() to log the whole key and value returned
    {% do log('First print =========', info=true) %}
    {% for key, value in dict.items() %}
        {% do log(key, info=true) %}
        {% do log(value, info=true) %}
    {% endfor %} 

    -- We can use it in conjunction with a string! Neat huh?
    -- Also, we can check if each key in the dict, if it is part of the list
    {% do log('Second print =========', info=true) %}
    {% for key, value in dict.items() %}
        {% if key in list %}
            {% do log(key ~ ' is in the list!', info=true) %}
        {% endif %}
    {% endfor %} 

    -- Now we want to log if it is not in the list
    {% do log('Third print =========', info=true) %}
    {% for key, value in dict.items() %}
        {% if key not in list %}
            {% do log(key ~ ' is not in the list!', info=true) %}
        {% endif %}
    {% endfor %} 

    -- Now lets check the item employed inside the dict
    {% do log('Fourth print =========', info=true) %}
    {% for key, value in dict.items() %}
        {% if value.employed == true %}
            {% do log(key ~ ' is employed!', info=true) %}
        {% endif %}
    {% endfor %} 

{% endmacro %}
