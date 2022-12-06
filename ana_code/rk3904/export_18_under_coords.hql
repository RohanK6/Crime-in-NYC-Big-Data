INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_18_under' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM arrest_data 
WHERE age_group='<18' 
ORDER BY latitude, longitude DESC;