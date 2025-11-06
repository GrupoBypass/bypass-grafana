CREATE EXTERNAL TABLE bypass_table_dps (
  id_circuito string,
  modelo string,
  categoria string,
  prioridade int,
  status string,
  num_carro string,
  num_trem string,
  datahora string,
  pico_tensao_kv double,
  corrente_surto_ka double
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'quoteChar' = '"',
    'separatorChar' = ','
)
STORED AS TEXTFILE
LOCATION 's3://${S3_CLIENT}/dps/'
TBLPROPERTIES ('skip.header.line.count'='1');

