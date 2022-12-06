INSERT OVERWRITE DIRECTORY '/user/al6178/CrimeProject/export' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT latitude, longitude 
FROM shooting_data
WHERE perp_age_group='18-24'
ORDER BY latitude, longitude DESC;