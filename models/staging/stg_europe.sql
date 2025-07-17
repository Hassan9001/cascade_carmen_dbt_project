-- models/staging/stg_europe.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('europe') }}
from {{ ref('raw_europe') }}
