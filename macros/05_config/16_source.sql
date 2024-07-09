{%- macro source(source_name, table_name) -%}

    /* 
        This is an example of a vanilla source. Notice how it will only get the
        source_name and table_name, as usual.

        But of course, the builtins.source dbt function has a more complex logic
        defined in it, which you can discover by checking the dbt-core python module
        code.

        But dbt provide it as a function here so we can call it however we want.

        In this example, we are just calling the function and returning its results.
    */

    {% set rel = builtins.source(source_name, table_name) %}
    {% do return(rel) %}

{%- endmacro -%}