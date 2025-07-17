-- models/staging/stg_asia.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('asia') }}
from {{ ref('raw_asia') }}
