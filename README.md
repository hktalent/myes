
# How run
```bash
docker run -p 9200:9200 -p 9300:9300 -d --name es -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v $PWD/conf/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v $PWD/conf/analysis-ik:/usr/share/elasticsearch/config/analysis-ik -v $PWD/data:/usr/share/elasticsearch/data -v $PWD/plugins:/usr/share/elasticsearch/plugins  elasticsearch:7.16.2
```
## install plugin
```bash
find . -name ".DS_Store" -delete
bin/elasticsearch-plugin install ingest-attachment
bin/elasticsearch-plugin install discovery-ec2
bin/elasticsearch-plugin install discovery-azure-classic
bin/elasticsearch-plugin install discovery-gce
bin/logstash-plugin install logstash-input-jdbc
```


```
docker export -o myes.tar 17a25bffa763

docker port es 9300
```
