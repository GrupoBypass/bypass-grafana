CREATE EXTERNAL TABLE bypass_table_wordcloud (
  palavra string,
  frequencia int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'quoteChar' = '"',
    'separatorChar' = ','
)
STORED AS TEXTFILE
LOCATION 's3://${S3_CLIENT}/wordcloud/'
TBLPROPERTIES ('skip.header.line.count'='1');

