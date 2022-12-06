INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_all' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM arrest_data 
ORDER BY latitude, longitude DESC;