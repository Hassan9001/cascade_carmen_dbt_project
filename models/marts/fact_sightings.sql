-- models/marts/fact_sightings.sql
{{ config(materialized='table') }}

select
    {{ dbt_utils.generate_surrogate_key(['date_witness', 'witness', 'agent', 'city', 'country']) }} as sighting_id,
    cast(date_witness as date) as date_witness,
    cast(date_agent as date) as date_agent,
    witness,
    agent,
    city,
    country,
    city_agent,
    cast(latitude as float) as latitude,
    cast(longitude as float) as longitude,
    cast(has_weapon as boolean) as has_weapon,
    cast(has_hat as boolean) as has_hat,
    cast(has_jacket as boolean) as has_jacket,
    behavior,
    region
from {{ ref('int_unified_sightings') }}
where date_witness is not null
  and latitude is not null
  and longitude is not null


