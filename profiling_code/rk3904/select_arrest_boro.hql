SELECT arrest_boro, count(*) 
FROM arrest_data
GROUP BY arrest_boro;