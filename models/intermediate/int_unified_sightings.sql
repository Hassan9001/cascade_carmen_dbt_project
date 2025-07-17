-- models/intermediate/int_unified_sightings.sql
{{ config(materialized='view') }}

select * from {{ ref('stg_europe') }}
union all
select * from {{ ref('stg_asia') }}
union all
select * from {{ ref('stg_africa') }}
union all
select * from {{ ref('stg_america') }}
union all
select * from {{ ref('stg_australia') }}
union all
select * from {{ ref('stg_atlantic') }}
union all
select * from {{ ref('stg_indian') }}
union all
select * from {{ ref('stg_pacific') }}
