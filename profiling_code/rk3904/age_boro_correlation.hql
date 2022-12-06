SELECT age_group, arrest_boro, count(*) 
FROM arrest_data 
GROUP BY age_group, arrest_boro;