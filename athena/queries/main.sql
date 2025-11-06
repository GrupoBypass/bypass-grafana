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
TBLPROPERTIES (
    'skip.header.line.count'='1'
);


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
LOCATION 's3://NOVO_BUCKET/NOVO_PREFIXO/'
TBLPROPERTIES (
  'skip.header.line.count'='1'
);



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
TBLPROPERTIES (
  'skip.header.line.count'='1'
);



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
TBLPROPERTIES (
    'skip.header.line.count'='1'
);



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
TBLPROPERTIES (
    'skip.header.line.count'='1'
);



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
TBLPROPERTIES (
    'skip.header.line.count'='1'
);



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
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '\"',
  'escapeChar' = '\\',
  'ignoreLeadingWhiteSpace'='true',
  'ignoreTrailingWhiteSpace'='true'
)
LOCATION 's3://${S3_CLIENT}/piezo'
TBLPROPERTIES ('skip.header.line.count'='1');



CREATE EXTERNAL TABLE bypass_table_tof (
    y_block int,
    x_block int,
    dist string,
    timestamp STRING,
    trem_id STRING,
    carro_id STRING
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '\"',
  'escapeChar' = '\\',
  'ignoreLeadingWhiteSpace'='true',
  'ignoreTrailingWhiteSpace'='true'
)
LOCATION 's3://${S3_CLIENT}/tof/'
TBLPROPERTIES ('skip.header.line.count'='1');



CREATE EXTERNAL TABLE bypass_table_optico (
    timestamp STRING,
    train_id int,
    brake_pad_id string,
    brake_pad_mm STRING,
    sla_status STRING
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '\"',
  'escapeChar' = '\\',
  'ignoreLeadingWhiteSpace'='true',
  'ignoreTrailingWhiteSpace'='true'
)
LOCATION 's3://${S3_CLIENT}/optical/'
TBLPROPERTIES ('skip.header.line.count'='1');
