{% macro hello_world_with_args(string = "Hello World!") %}

    {% do print(string) %}

{% endmacro %}
