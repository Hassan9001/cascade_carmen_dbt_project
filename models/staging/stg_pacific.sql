-- models/staging/stg_pacific.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('pacific') }}
from {{ ref('raw_pacific') }}
