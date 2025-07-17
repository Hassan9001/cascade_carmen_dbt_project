-- models/marts/analytics/behavior_analysis.sql
{{ config(materialized='view') }}

select
    behavior,
    count(*) as frequency,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as percentage,
    rank() over (order by count(*) desc) as behavior_rank
from {{ ref('fact_sightings') }}
where behavior is not null
group by behavior
order by frequency desc