
# How run
```bash
docker run --restart=always --ulimit nofile=65536:65536 -p 9200:9200 -p 9300:9300 -d --name es -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v $PWD/logs:/usr/share/elasticsearch/logs -v $PWD/conf/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v $PWD/conf/analysis-ik:/usr/share/elasticsearch/config/analysis-ik -v $PWD/data:/usr/share/elasticsearch/data -v $PWD/plugins:/usr/share/elasticsearch/plugins  elasticsearch:7.16.2

# docker update --restart  always es

docker run -p 9200:9200 -p 9300:9300 -d --name es -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v $PWD/conf:/usr/share/elasticsearch/config -v `pwd`/logs:/usr/share/elasticsearch/logs -v $PWD/data:/usr/share/elasticsearch/data -v $PWD/plugins:/usr/share/elasticsearch/plugins  elasticsearch:7.16.2

# How export/import data
https://github.com/elasticsearch-dump/elasticsearch-dump
```bash

rm -rf plugins/*
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.16.2/elasticsearch-analysis-ik-7.16.2.zip
./bin/elasticsearch-plugin install analysis-icu
./bin/elasticsearch-plugin install discovery-azure-classic
./bin/elasticsearch-plugin install ingest-attachment
./bin/elasticsearch-plugin install discovery-ec2

npm install elasticdump -g
elasticdump --input=http://127.0.0.1:9200/cve_index --output=http://192.168.0.100:9200/cve_index --concurrency=8 --limit=20000 --type=data
# Backup
elasticdump --input=http://127.0.0.1:9200/cve_index --output=bak.json --type=data
# Import templates into ES
elasticdump --input=./bak.json --output=http://127.0.0.1:9200 --type=cve_index

# go install github.com/medcl/esm@latest
git clone https://github.com/medcl/esm
cd esm
make build
esm  -s http://127.0.0.1:9200  -d http://192.168.0.112:9200 -x cve_index  -y cve_index -w=5 -b=10 -c 10000

esm  -s http://192.168.0.100:9200  -d http://192.168.0.112:9200 -x ip2domain_index  -y ip2domain_index -w=5 -b=10 -c 10000

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
# 集群
```
PUT /_cluster/settings HTTP/1.1
host:127.0.0.1:9200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15
Connection: close
Content-Type: application/json;charset=UTF-8
Content-Length: 187

{
  "persistent" : {
    "cluster" : {
      "remote" : {
        "node-2" : {
          "seeds" : [
            "192.168.0.100:9300"
          ]
        }
      }
    }
  }
}
```

```
PUT /_cluster/settings HTTP/1.1
host:192.168.0.100:9200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15
Connection: close
Content-Type: application/json;charset=UTF-8
Content-Length: 187

{
  "persistent" : {
    "cluster" : {
      "remote" : {
        "node-2" : {
          "seeds" : [
            "192.168.0.107:9300"
          ]
        }
      }
    }
  }
}
```
# 常用操作
## 删除索引
```
DELETE /site_index* HTTP/1.1
host:127.0.0.1:9200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15
Connection: close
Content-Type: application/json;charset=UTF-8
Content-Length: 0


```
## 创建索引
```
PUT /site_index HTTP/1.1
host:127.0.0.1:9200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15
Connection: close
Content-Type: application/json;charset=UTF-8
Content-Length: 405

{
  "settings": {
   "analysis": {
     "analyzer": {
       "default": {
         "type": "custom",
         "tokenizer": "ik_smart",
         "char_filter": [
            "html_strip"
          ]
       },
       "default_search": {
         "type": "custom",
         "tokenizer": "ik_smart",
         "char_filter": [
            "html_strip"
          ]
      }
     }
   }
  }
}
```
### others
```
查看文档数量
http://127.0.0.1:9200/_cat/count/site_index?v
http://127.0.0.1:9200/_cat/count?v

查看插件
http://127.0.0.1:9200/_cat/plugins?v&s=component&h=name,component,version,description

一般查询
http://127.0.0.1:9200/cve_index/_search?q=CVE&pretty=true&track_total_hits=true

http://127.0.0.1:9200/cve_index/cve/_search?pretty=true&q=cpe23Uri:%20in%20%22cpe:2.3:a:apache:log4j%22&sort=lastModifiedDate:desc
看索引配置情况
http://127.0.0.1:9200/cve_index?pretty=true
看设置
http://127.0.0.1:9200/cve_index/_settings?pretty=true
看映射关系
http://127.0.0.1:9200/cve_index/_mapping?pretty=true
查看集群节点
http://127.0.0.1:9200/_cat/nodes?pretty
查看集群配置
http://127.0.0.1:9200/_cluster/settings?pretty=true

查看插件状态
http://127.0.0.1:9200/_plugin/head/
集群状态查看
http://localhost:9200/_cluster/health?pretty=true

分片状态查看
http://localhost:9200/_cat/shards?v

查看unassigned 的原因，无法分配的 Shard 并解释原因
http://localhost:9200/_cluster/allocation/explain?pretty=true
查看集群中不同节点、不同索引的状态
http://localhost:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason

http://127.0.0.1:9200/site_index/_doc/_search?q=Server:%20in%20%22Apache%22&pretty=true&_source_excludes=responseBody,js

http://127.0.0.1:9200/site_index/_doc/_search?q=Server:%20IN%20*Apache*&pretty=true&_source_excludes=responseBody,js,unsafeser

http://127.0.0.1:9200/site_index/_doc/_search?q=Server:%20IN%20*Apache*&pretty=true&_source_includes=headers.Server

http://127.0.0.1:9200/site_index/_doc/_search?pretty=true&source_content_type=application/json&source={%22query%22:{%22Server%22:%22Apache%22}}

http://127.0.0.1:9200/site_index/_doc/_search?q=+Server:IN%20*Apache*&pretty=true&_source_includes=headers.Server

http://127.0.0.1:9200/site_index/_settings?flat_settings=true&pretty=true

http://127.0.0.1:9200/site_index/_doc/_search?q=Server:%20IN%20%22Apache%22&pretty=true&_source_excludes=responseBody,js,headers.Link


```
