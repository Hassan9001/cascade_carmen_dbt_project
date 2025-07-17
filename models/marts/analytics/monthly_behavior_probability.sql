-- models/marts/analytics/monthly_behavior_probability.sql
{{ config(materialized='view') }}

with top_behaviors as (
    select behavior
    from {{ ref('behavior_analysis') }}
    where behavior_rank <= 3
),
monthly_behavior_stats as (
    select
        cast(extract(month from date_witness) as integer) as month_n,
        count(*) as total_per_month,
        sum(case when behavior in (select behavior from top_behaviors) then 1 else 0 end) as top_behavior_count
    from {{ ref('fact_sightings') }}
    group by month_n
)
select
    month_n,
    total_per_month,
    top_behavior_count,
    round(top_behavior_count::numeric / nullif(total_per_month,0), 4) as top_behavior_probability
from monthly_behavior_stats
order by month_n