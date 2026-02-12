{% macro generate_surrogate_key(columns) -%}
  {# 
    This macro generates a **surrogate key** for a dimension table.
    Input: a list of columns (usually business keys)
    Output: a stable, unique integer ID using Snowflake's farm_fingerprint
  #}

  farm_fingerprint(
    concat(
      {{ columns | map(attribute='sql') | join(",'|',") }}
    )
  )

{%- endmacro %}
