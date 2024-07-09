{% 
    macro comments(
        string = "Hello, "
        , other_string = "World"
    ) 
%}

{#
    This macro will print a hello world message, isnt it cool?
#}

/*
    This macro will print a hello world message, isnt it cool?
*/

    {% do print(string ~ other_string ~ "!") %}

{% endmacro %}
