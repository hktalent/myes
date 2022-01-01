# 构建之前最好将es目录赋予777权限
# https://hub.docker.com/_/elasticsearch
#  -e "discovery.type=single-node" 
docker run -p 9200:9200 -p 9300:9300 -d --name es -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v $PWD/conf/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v $PWD/data:/usr/share/elasticsearch/data -v $PWD/plugins:/usr/share/elasticsearch/plugins --privileged=true elasticsearch:7.14.2
docker logs -f es
open "https://127.0.0.1:9200/"
curl -o- -s -k 'http://127.0.0.1:9200/_cat/health'|grep -Eo '\d{7,} \d{2}:\d{2}:\d{2}'&&echo 'is ok'

curl -o- -s -k 'http://0:9200/_cat/indices?v&s=docs.count'

# 查看Elasticsearch 索引状态 (*表示ES集群的master主节点)
curl -XGET 'http://0:9200/_cat/indices?v'
# 心跳检测  /_cat/health?format=json
curl -o- -s  -k 'http://0:9200/_cat/health'
# 节点健康检测  /_cat/nodes?format=json
curl 'http://0:9200/_cat/nodes?v'
curl 'http://0:9200/_cluster/health?pretty' 

# 查看分片状态
curl -XGET 'http://0:9200/_cluster/health?pretty'
# 复制为0，删除切片
curl -XPUT "http://localhost:9200/_settings" -d' {  "number_of_replicas" : 0 } '

wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.16.2/elasticsearch-analysis-ik-7.16.2.zip
docker cp elasticsearch-analysis-ik-7.16.2.zip es:/usr/share/elasticsearch
bin/elasticsearch-plugin install file:///${PWD}/elasticsearch-analysis-ik-7.16.2.zip
bin/elasticsearch-plugin install ingest-attachment

# https://juejin.cn/post/6844903728667951111
# 创建index PUT /customer
# 查看所有index  GET /_cat/indices?format=json
# 删除index DELETE /customer
# 按ID新增数据 
# PUT /customer/doc/1
# {
#   "name": "John Doe"
# }

# PUT /customer/doc/2
# {
#   "name": "yujc",
#   "age":22
# }

# # 按ID查询数据 GET /customer/doc/1
# 按ID更新数据
#     我们使用下面两种方式均能更新已有数据：
#     PUT /customer/doc/1
# {
#   "name": "yujc2",
#   "age":22
# }
# POST /customer/doc/1
# {
#   "name": "yujc2",
#   "age":22
# }
# 以上操作均会覆盖现有数据

# 更新部分字段(_update)
# POST /customer/doc/1/_update
# {
#   "doc":{"name": "yujc"}
# }

# 增加字段：
# POST /customer/doc/1/_update
# {
#   "doc":{"year": 2018}
# }

