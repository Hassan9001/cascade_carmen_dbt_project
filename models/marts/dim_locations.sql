-- models/marts/dim_locations.sql
{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['city', 'country']) }} as location_id,
    city,
    country,
    cast(latitude as float) as latitude,
    cast(longitude as float) as longitude,
    region
from {{ ref('int_unified_sightings') }}
where city is not null
  and country is not null
  and latitude is not null
  and longitude is not null
