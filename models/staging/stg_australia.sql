-- models/staging/stg_australia.sql
{{ config(materialized='view') }}

select
    {{ standardize_columns('australia') }}
from {{ ref('raw_australia') }}

