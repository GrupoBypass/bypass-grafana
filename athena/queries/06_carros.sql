CREATE EXTERNAL TABLE bypass_table_carros (
  valor_carro string,
  id_carro int,
  plataforma int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'quoteChar' = '"',
    'separatorChar' = ','
)
STORED AS TEXTFILE
LOCATION 's3://${S3_CLIENT}/carros/'
TBLPROPERTIES ('skip.header.line.count'='1');

