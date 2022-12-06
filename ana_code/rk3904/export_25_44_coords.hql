INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_25_44' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM arrest_data 
WHERE age_group='25-44' 
ORDER BY latitude, longitude DESC;