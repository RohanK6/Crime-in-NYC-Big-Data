CREATE EXTERNAL TABLE shooting_data (incident_key BIGINT, occur_date STRING, boro STRING, stat_murder_flag STRING, perp_age_group STRING, perp_sex STRING, vic_age_group STRING, vic_sex STRING, x_coord_cd STRING, y_coord_cd STRING, latitude STRING, longitude STRING)
COMMENT 'NYPD Shooting Data'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
LOCATION '/user/al1678/CrimeProject/input';
