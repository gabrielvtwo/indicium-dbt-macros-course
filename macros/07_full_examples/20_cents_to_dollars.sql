{%- macro cents_to_dollars(column_name, scale=2) -%}
round(cast(({{ column_name }} / 100) as numeric), {{ scale }})
{%- endmacro -%}