{{ config(materialized='view') }}

with monthly_city_counts as (
    select
        extract(month from date_witness) as month_n,
        city_agent,
        count(*) as record_count
    from {{ ref('fact_sightings') }}
    group by month_n, city_agent
),
ranked_cities as (
    select
        month_n,
        city_agent,
        record_count,
        row_number() over (partition by month_n order by record_count desc) as rn
    from monthly_city_counts
)
select
    month_n,
    city_agent,
    record_count
from ranked_cities
where rn = 1
order by month_n