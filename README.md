
# Crime Project

As part of a  _Processing Big Data and Analytics_  course offered at NYU, we were tasked with finding publicly-available data and conducting an analysis leveraging several big data tools. For this project, my group member and I decided to focus in on the city we live in — New York City.

We were curious about where crime was happening most, as well as the frequency of crime within different age demographics. 

The project overview may be read either below or on [Medium](https://medium.com/@rk3904/trends-in-nyc-crime-an-analysis-with-mapreduce-and-hiveql-c575c7d8368b).

## Table of Contents
- [Crime Project](#crime-project)
  * [Project Overview](#project-overview)
    + [NYPD Data](#nypd-data)
    + [MapReduce](#mapreduce)
    + [Hive](#hive)
    + [Benefit of HiveQL](#benefit-of-hiveql)
    + [Findings](#findings)
    + [Conclusion](#conclusion)
  * [Directories](#directories)
    + [ana_code](#ana_code)
    + [data_ingest](#data_ingest)
    + [etl_code](#etl_code)
    + [profiling_code](#profiling_code)
    + [screenshots](#screenshots)
    + [test_code](#test_code)
  * [How to build the code](#how-to-build-the-code)
  * [How to run the code](#how-to-run-the-code)
  * [Results of runs](#results-of-runs)
  * [Additional Note](#additional-note)

## Project Overview

### NYPD Data

For this project, we turned to  [NYC OpenData](https://opendata.cityofnewyork.us/), a platform that provides significant amounts of data for the public to view and use. From this, we were successful in finding two useful datasets:

1.  NYPD Arrest Data Year to Date:  [https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc)
2.  NYPD Shooting Incident Data (Historic):  [https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Historic-/833y-fsy8](https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Historic-/833y-fsy8)

The similarity of these two datasets allowed us to conduct an analysis on our desired two analytics, location and age. Yet the difference in the severity of the crime (i.e. general crime vs. shootings) allowed for a deeper insight into the  _kind_  of crimes committed in different locations and within different age demographics.

### MapReduce

Due to the size of these datasets, processing over 125,000+ data entries seemed like the perfect time to leverage the  [Hadoop MapReduce](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)  framework — we could easily clean the datasets with MapReduce in order to make later analytics and research much more conclusive.

One of the major priorities, therefore, was to drop the unneeded columns within each of our datasets.
```java
public void map(Object key, Text value, Context context) throws IOException, InterruptedException {  
  String line = value.toString();  
  String[] fields = line.split(",");  
  
  // An indices array to specify what columns of the fields we want to keep  
  int[] indices = {0, 1, 6, 9, 10, 14, 15};  
   
  // Copy those specific indices into a new array  
  String[] cleanedFields = Arrays.stream(indices).mapToObj(i -> fields[i]).toArray(String[]::new);  
        
  // Join all of the new array elements into one single Text() element to write  
  Text cleanedRecord = new Text(String.join(",", cleanedFields));  
    
  if (!cleanedFields[3].equals("AGE_GROUP")) {  
    context.write(cleanedRecord, defaultValue);  
    }  
  }
```

This is a sample  `Mapper`  that was used in our cleaning process, dropping all of the columns not included in our  `indices`  array, and filtering out rows and data that were incorrectly parsed. The outputs of these results were stored in HDFS, for the next step of our analysis.

### Hive

For the next steps, we decided to create an external table (i.e. the table pointed to the output from the previous Mapper in HDFS) for each of the datasets.

```sql
CREATE EXTERNAL TABLE arrest_data(arrest_key BIGINT, arrest_date STRING, arrest_boro STRING, age_group STRING, perp_sex STRING, latitude STRING, longitude STRING)  
COMMENT 'NYPD Arrest Data'  
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE  
LOCATION '/user/rk3904/DataCleaning/output';
```

Once we had our table created in Hive, we could use a series of HiveQL queries by connecting through  `beeline`  and then running our queries in the shell interface. Some queries that we ran included:

1.  Count the number of crimes committed, per age group, in each borough
```sql
SELECT age_group, arrest_boro, count(*)   
FROM arrest_data   
GROUP BY age_group, arrest_boro;
```

2. Retrieve the proportion of crime committed respective to each age group
```sql
SELECT age_group, (count(*)/140565)*100 as percent_group  
FROM arrest_data   
GROUP BY age_group;
```

3. Retrieve the proportion of crime committed respective to each borough
```sql
SELECT arrest_boro, (count(*)/140565)*100 as percent_group  
FROM arrest_data  
GROUP BY arrest_boro;
```

### Benefit of HiveQL

One of the main reasons we ended up using HiveQL for the majority of our analytics is that it allowed us to do more with less. We were looking into the best way that we could export the (latitude, longitude) coordinates from each dataset for each age group so we could analyze the data at an age-specific level. However, with MapReduce, this would have required at least 5 different programs, each needed a Driver, Mapper, and potential Reducer.

With HiveQL, we were able to circumvent this, and simply query all coordinates using a  `WHERE`  clause to isolate specific age groups, and write them to an external file for our own processing later.
```sql
INSERT OVERWRITE DIRECTORY '/user/rk3904/CrimeProject/export_18_24'   
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','   
SELECT latitude, longitude   
FROM arrest_data   
WHERE age_group='18-24'   
ORDER BY latitude, longitude DESC;
```

### Findings

After accumulating a lot of profiled data and queried results, one of the final steps was to create a visualization. For this, we used  [QGIS](https://qgis.org/en/site/), a useful tool that supports analysis of geospatial data.

With this, we were able to visualize results for both of our desired analytics — location and age.

<p align="center">
  <img src="https://miro.medium.com/v2/resize:fit:1008/format:webp/1*l6ad_2LWp1pXP6El2U324g.png" width="400" />
  <img src="https://miro.medium.com/v2/resize:fit:994/format:webp/1*QC1EMR6UoieZX7ROte53OA.png" width="400" /> 
</p>

<p align="center">
  <em>Arrests made on 18–24 year olds for general crime (left) and shootings (right)</em>
</p>


Above is just one of the several visualizations we made through QGIS, as we were able to (as mentioned above) export coordinates of arrests made, for each dataset, isolated to specific age groups. As demonstrated by the graph, the lighter colors represent lower crime densities, and the darker colors represent a higher crime density. This gives us valuable insight into both age and location for crime.

### Conclusion

Whilst our findings for this project were extremely interesting, we were curious to know if we could really  _predict_  crime based on data. Our answer was that, while we could not actually predict it, we were able to observe consistent trends in data. One notable finding was that 57.67% of the general crime committed was done by 25–44 year olds, and 44.25% of the shootings were by 18–24 year olds.

Due to this, we believe that there is use for this analytic — it highlights the trends in data, and therefore allows the right people to make better, informed decisions when trying to understand why crime occurs and why certain age groups may be committing it more frequently than others.
  

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

al6178 (the ana_code exports a CSV file located in /user/al6178/CrimeProject/export/000000_0)

rk3904 (the etl_code results will be in “/user/rk3904/DataCleaning/output/part-r-00000)

rk3904 (the ana_code results will be in “user/rk3904/CrimeProject/output_18_under/000000_0 → for each file)

The profiling_code does not export anything into a file, instead, the queries are run and the output of the query in the terminal is used for information to help with the ETL process.

  

## Additional Note
Within each directory, there are two subdirectories to separate the queries / code by Alvin (al6178) and Rohan (rk3904).