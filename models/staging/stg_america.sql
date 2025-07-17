-- models/staging/stg_america.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('america') }}
from {{ ref('raw_america') }}

