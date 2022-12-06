INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_18_24' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM arrest_data 
WHERE age_group='18-24' 
ORDER BY latitude, longitude DESC;