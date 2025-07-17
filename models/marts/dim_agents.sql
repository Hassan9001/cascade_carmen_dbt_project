-- models/marts/dim_agents.sql
{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['agent', 'city_agent']) }} as agent_id,
    agent,
    city_agent as agent_hq_city,
    region
from {{ ref('int_unified_sightings') }}
where agent is not null
  and city_agent is not null
