{%- macro crazy_source(source_name, table_name, percent = 10, enabled = true) -%}

    /* 
        Now in this example we are making a neat change to the macro source.

        We can opt for calling it "crazy_source" inside a SQL or we can change its name
        to "source" to override the original functioning of the source macro.

        In this example, what we are doing is that we are calling the builtins.source function
        but we are expanding it with a tablesample SQL statement to create samples of our data.

        (If you are using another Data Warehouse, maybe the syntax will change for this, so beware)
    */

    -- We set the relation for the source
    {% set rel = builtins.source(source_name, table_name) %}

    -- We check if the target is dev and also if the macro is enabled
    {% if target.name == 'dev' and enabled is true %}
        -- The dbt developer can disable the macro for local usage by simple change of an argument

        -- Now we are overring the original rel with a rel + tablesample with a percent variable as well
        {% set rel = rel ~ ' tablesample system (' ~ percent ~ ' percent)' %}
        -- So the dbt developer can also change the percent if desired
    
    {% endif %}

    -- Finally, we are returning the new rel
    {% do return(rel) %}

{%- endmacro -%}