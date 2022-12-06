SELECT age_group, (count(*)/140565)*100 as percent_group
FROM arrest_data 
GROUP BY age_group;