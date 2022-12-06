SELECT arrest_boro, (count(*)/140565)*100 as percent_group
FROM arrest_data
GROUP BY arrest_boro;