-- Início:
-- cd /usr/local/hadoop/

-- sudo rm -r dfs
-- sudo rm -r nm-local-dir

-- bin/hdfs namenode -format

-- sbin/start-all.sh

-- cd /usr/local/sqoop

-- bin/sqoop import --connect jdbc:mysql://localhost/IGTI?zeroDateTimeBehavior=convert_To_Null --username root --password igti --table CLIENTE_VENDA -m 1 --bindie /usr/local/sqoop/lib --target-dir /igti

-- cd ..
-- cd/hadoop/

-- bin/hdfs dfs -cat /igti/part-m-00000
-- > consulta os dados

-- -------------------------------
-- cd ..
-- cd hive/
-- ls
-- /usr/local/hadoop/bin/hdfs dfs -mkdir /hive
-- /usr/local/hadoop/bin/hdfs dfs -ls /
-- ls
-- rm -rf metastore_db/
-- bin/schemaTool -initSchema -dbType derby
-- bin/hive --> shell do hive




-- Criar diretório Desafio:
-- /usr/local/hadoop/bin/hdfs dfs -mkdir /Desafio

-- Consultar diretórios no hdfs:
-- /usr/local/hadoop/bin/hdfs dfs -ls /

-- Transferir arquivo covidData.txt em /usr/local/hadoop:
-- bin/hdfs dfs -put /usr/local/hadoop/Dados/covidData.txt /Desafio

-- Iniciar o hive: --> pasta hive foi criada na aula
-- rm -rf metastore_db/
-- bin/schemaTool -initSchema -dbType derby
-- /usr/local/hive/bin/hive

-- Criar banco de dados:
create database dbDesafio;

-- Criar tabela:

CREATE TABLE DadosCovid (dataOcorrencia String, siglaPais String, descPais String, regiao String, novosCasos int, casosAcumulados int, novosObitos int, obitosAcumulados int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE LOCATION 'hive/Desafio/CasosCovid';

-- Consultar tabela:
SELECT * FROM DadosCovid  --> está vazia

-- Importação dos dados:

LOAD DATA INPATH 'hdfs://localhost:54310/Desafio/covidData.txt' INTO TABLE DadosCovid;

-- Consultar:
SELECT * FROM dadosCovid; --> deve estar populada com 17705 rows

-- -----------------------------------------
-- Consultas:

SELECT COUNT(*) FROM DadosCovid;
-- > executa um MapReduce
-- > 17705 linhas

select count(*) from DadosCovid where descPais="Uruguay"
-- > 74

select count(*) from DadosCovid where descPais="Brazil"
-- > 92

select avg(novosCasos) where descPais="France"
-- > 1141.632

select count(novosCasos) from DadosCovid where dataOcorrencia="2020-05-26T00:00:00Z";
-- > 215


select count(novosObitos) from DadosCovid where dataOcorrencia="2020-05-26T00:00:00Z";
-- > 215

describe extended DadosCovid;
-- > arquivo .odt
-- > 10 rows

select concat(dataOcorrencia, " ", siglaPais, " ", descPais) from DadosCovid where novosCasos = 501;
-- > 2020-03-11T00:00:00Z ES Spain

select regiao, count(1) from DadosCovid group by regiao order by regiao;

-- 	118
-- AFRO	3417
-- AMRO	4079
-- EMRO	1816
-- EURO	5431
-- SARO	970
-- WPRO	1874
