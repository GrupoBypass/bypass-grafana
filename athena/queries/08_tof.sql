CREATE EXTERNAL TABLE bypass_table_tof (
    y_block int,
    x_block int,
    dist string,
    timestamp STRING,
    trem_id STRING,
    carro_id STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '\"',
  'escapeChar' = '\\',
  'ignoreLeadingWhiteSpace'='true',
  'ignoreTrailingWhiteSpace'='true'
)
LOCATION 's3://${S3_CLIENT}/tof/'
TBLPROPERTIES ('skip.header.line.count'='1');

