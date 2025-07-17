-- models/staging/stg_africa.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('africa') }}
from {{ ref('raw_africa') }}

