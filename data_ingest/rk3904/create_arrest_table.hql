CREATE EXTERNAL TABLE arrest_data(arrest_key BIGINT, arrest_date STRING, arrest_boro STRING, age_group STRING, perp_sex STRING, latitude STRING, longitude STRING)
COMMENT 'NYPD Arrest Data'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
LOCATION '/user/rk3904/DataCleaning/output';