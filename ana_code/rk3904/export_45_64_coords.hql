INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_45_64' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM arrest_data 
WHERE age_group='45-64' 
ORDER BY latitude, longitude DESC;