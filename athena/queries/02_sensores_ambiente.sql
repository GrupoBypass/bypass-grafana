CREATE EXTERNAL TABLE nova_tabela_sensores_ambiente (
  datahora STRING,
  temperatura STRING,
  min STRING,
  max STRING,
  ocupacao_porcentagem STRING,
  umidade_porcentagem STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'escapeChar' = '\\',
  'quoteChar' = '"',
  'separatorChar' = ','
)
STORED AS TEXTFILE
LOCATION 's3://${S3_CLIENT}/sensores_ambiente/'
TBLPROPERTIES ('skip.header.line.count'='1');
