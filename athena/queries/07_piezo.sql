CREATE EXTERNAL TABLE bypass_table_piezo (
    trem_id STRING,
    sensor_id_origem STRING,
    sensor_id_destino STRING,
    pressao_kpa STRING,
    data_hora_inicio STRING,
    data_hora_fim STRING,
    velocidade_kmh STRING,
    headway STRING,
    trilho STRING,
    linha STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '\"',
  'escapeChar' = '\\',
  'ignoreLeadingWhiteSpace'='true',
  'ignoreTrailingWhiteSpace'='true'
)
LOCATION 's3://${S3_CLIENT}/piezo'
TBLPROPERTIES ('skip.header.line.count'='1');

