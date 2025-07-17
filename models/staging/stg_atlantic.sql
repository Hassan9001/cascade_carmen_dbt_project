-- models/staging/stg_atlantic.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('atlantic') }}
from {{ ref('raw_atlantic') }}