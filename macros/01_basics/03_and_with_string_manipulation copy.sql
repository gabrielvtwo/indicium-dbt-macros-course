{% 
    macro hello_world_with_args_string(
        string = "Hello, "
        , other_string = "World"
    ) 
%}

    {% do print(string ~ other_string ~ "!") %}

{% endmacro %}
