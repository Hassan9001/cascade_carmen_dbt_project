-- models/marts/analytics/monthly_appearance_probability.sql
{{ config(materialized='view') }}

select
    extract(month from date_witness) as month_n,
    count(*) as total_per_month,
    sum(case when has_weapon and has_jacket and not has_hat then 1 else 0 end) as conditional_per_month,
    round(
        sum(case when has_weapon and has_jacket and not has_hat then 1 else 0 end)::numeric / nullif(count(*),0),
        4
    ) as probability,
    -- Supplementary metrics
    sum(case when has_weapon then 1 else 0 end) as armed_count,
    sum(case when has_hat then 1 else 0 end) as hat_count,
    sum(case when has_jacket then 1 else 0 end) as jacket_count,
    round(sum(case when has_weapon then 1 else 0 end)::numeric / nullif(count(*),0), 4) as armed_probability,
    round(sum(case when has_hat then 1 else 0 end)::numeric / nullif(count(*),0), 4) as hat_probability,
    round(sum(case when has_jacket then 1 else 0 end)::numeric / nullif(count(*),0), 4) as jacket_probability
from {{ ref('fact_sightings') }}
group by month_n
order by month_n