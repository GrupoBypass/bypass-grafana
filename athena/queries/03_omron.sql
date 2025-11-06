CREATE EXTERNAL TABLE bypass_table_omron (
  x STRING,
  y STRING,
  valormatriz STRING,
  plataforma STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'quoteChar' = '"',
  'separatorChar' = ','
)
STORED AS TEXTFILE
LOCATION 's3://${S3_CLIENT}/omron/'
TBLPROPERTIES ('skip.header.line.count'='1');

