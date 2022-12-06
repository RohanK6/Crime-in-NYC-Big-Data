# Crime Project

## Directories

### ana_code

In ana_code, there will be HQL queries that perform complex analytics on the data sets, alongside a set of queries to extract the coordinates of arrests made on each age group - this means that we now have a detailed analysis of the proportions of arrests on each age group along with the coordinates to use in a visualization.

### data_ingest

In data_ingest you will find the HQL query to populate a hive table using an external table located in your HDFS directory where the data is located.

### etl_code

In etl_code, you will find MapReduce codes which clean the data to make sure only data we can analyze remains. For the shooting data, two cleans are required, the first clean is to select the correct columns, and the second clean is to remove the null values and bad group names.

### profiling_code

In profiling_code you will find HQL queries used to describe what the data looks like. The profiling code will provide information about existing unwanted data groups such as null values or incorrect group names. It will also give information about total row count and row count for each group.

### screenshots

In the screenshots directory, the screenshots of each of the .hql files and .java files being executed / displayed will be shown.

### test_code

This directory will be empty, 

## How to build the code

To build the etl_code, follow the instructions to compile .java files into .class files, and then create a .jar to run the MapReduce command. 


## How to run the code

To run the code, you can copy the HQL queries and run them directly in your beeline shell. If you are using the Hive CLI, you can run the code by running 
```bash
hive -f filename.hql
```
However, Hive CLI is deprecated and migration to Beeline is recommended.


## Results of runs

The results of the run can be found in the HDFS Directories of each of 
	al6178 (the etl_code results will be in /user/al6178/CrimeProject/output/part-r-00000)
    al6178 (the ana_code exports a CSV file located in  
		/user/al6178/CrimeProject/export/000000_0)
	rk3904 (the etl_code results will be in “/user/rk3904/DataCleaning/output/part-r-00000) 
	rk3904 (the ana_code results will be in 
		 “user/rk3904/CrimeProject/output_18_under/000000_0 → for each file)

The profiling_code does not export anything into a file, instead, the queries are run and the output of the query in the terminal is used for information to help with the ETL process.

## Additional Note

Within each directory, there are two subdirectories to separate the queries / code by Alvin (al6178) and Rohan (rk3904).
