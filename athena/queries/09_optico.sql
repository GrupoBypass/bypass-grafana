CREATE EXTERNAL TABLE bypass_table_optico (
    timestamp STRING,
    train_id int,
    brake_pad_id string,
    brake_pad_mm STRING,
    sla_status STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '\"',
  'escapeChar' = '\\',
  'ignoreLeadingWhiteSpace'='true',
  'ignoreTrailingWhiteSpace'='true'
)
LOCATION 's3://${S3_CLIENT}/optical/'
TBLPROPERTIES ('skip.header.line.count'='1');
