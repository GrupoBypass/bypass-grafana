CREATE EXTERNAL TABLE bypass_table_ocupacao (
    sensor_id STRING,
    trem_id STRING,
    carro_id STRING,
    datahora STRING,
    ocupacao_media DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'quoteChar' = '"',
    'separatorChar' = ','
)
STORED AS TEXTFILE
LOCATION 's3://${S3_CLIENT}/ocupacao/'
TBLPROPERTIES ('skip.header.line.count'='1');

