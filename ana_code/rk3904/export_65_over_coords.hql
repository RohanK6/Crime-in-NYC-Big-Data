INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_65_over' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM arrest_data 
WHERE age_group='65' 
ORDER BY latitude, longitude DESC;