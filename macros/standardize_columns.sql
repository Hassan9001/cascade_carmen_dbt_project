-- macros/standardize_columns.sql
{% macro standardize_columns(region_name) %}
    {% if region_name == 'europe' %}
        cast(date_witness as date) as date_witness,
        cast(date_filed as date) as date_agent,
        witness,
        agent,
        cast(lat_ as float) as latitude,
        cast(long_ as float) as longitude,
        city,
        country,
        region_hq as city_agent,
        case 
            when lower(trim(("armed?")::text)) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(("chapeau?")::text)) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(("coat?")::text)) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        observed_action as behavior,
        region
    {% elif region_name == 'asia' %}
        cast(sighting as date) as date_witness,
        cast("报道" as date) as date_agent,
        citizen as witness,
        officer as agent,
        cast("纬度" as float) as latitude,
        cast("经度" as float) as longitude,
        city,
        nation as country,
        city_interpol as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        behavior,
        region
    {% elif region_name == 'africa' %}
        cast(date_witness as date) as date_witness,
        cast(date_agent as date) as date_agent,
        witness,
        agent,
        cast(latitude as float) as latitude,
        cast(longitude as float) as longitude,
        city,
        country,
        region_hq as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        behavior,
        region
    {% elif region_name == 'america' %}
        cast(date_witness as date) as date_witness,
        cast(date_agent as date) as date_agent,
        witness,
        agent,
        cast(latitude as float) as latitude,
        cast(longitude as float) as longitude,
        city,
        country,
        region_hq as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        behavior,
        region
    {% elif region_name == 'australia' %}
        cast(witnessed as date) as date_witness,
        cast(reported as date) as date_agent,
        observer as witness,
        field_chap as agent,
        cast(lat as float) as latitude,
        cast(long as float) as longitude,
        place as city,
        nation as country,
        interpol_spot as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        state_of_mind as behavior,
        region
    {% elif region_name == 'atlantic' %}
        cast(date_witness as date) as date_witness,
        cast(date_agent as date) as date_agent,
        witness,
        agent,
        cast(latitude as float) as latitude,
        cast(longitude as float) as longitude,
        city,
        country,
        region_hq as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        behavior,
        region
    {% elif region_name == 'indian' %}
        cast(date_witness as date) as date_witness,
        cast(date_agent as date) as date_agent,
        witness,
        agent,
        cast(latitude as float) as latitude,
        cast(longitude as float) as longitude,
        city,
        country,
        region_hq as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        behavior,
        region
    {% elif region_name == 'pacific' %}
        cast(sight_on as date) as date_witness,
        cast(file_on as date) as date_agent,
        sighter as witness,
        filer as agent,
        cast(lat as float) as latitude,
        cast(long as float) as longitude,
        town as city,
        nation as country,
        report_office as city_agent,
        case 
            when lower(trim(cast(has_weapon as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_weapon,
        case 
            when lower(trim(cast(has_hat as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_hat,
        case 
            when lower(trim(cast(has_jacket as text))) in ('yes', 'true', '1') then true 
            else false 
        end as has_jacket,
        behavior,
        region
    {% endif %}
{% endmacro %}