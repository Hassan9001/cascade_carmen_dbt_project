-- models/staging/stg_indian.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('indian') }}
from {{ ref('raw_indian') }}
