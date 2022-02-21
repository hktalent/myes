docker stop es es1 es2
docker rm es es1 es2
docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 esnet
docker run --restart=always --ulimit nofile=65536:65536  --net esnet -p 9200:9200 -p 9300:9300 -d --name es -v $PWD/logs:/usr/share/elasticsearch/logs -v $PWD/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v $PWD/config/jvm.options:/usr/share/elasticsearch/config/jvm.options  -v $PWD/data:/usr/share/elasticsearch/data  hktalent/elasticsearch:7.16.2
cd node_ingest
docker run --restart=always --ulimit nofile=65536:65536  --net esnet -p 9202:9202 -p 9302:9302 -d --name es1 -v $PWD/logs:/usr/share/elasticsearch/logs -v $PWD/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v $PWD/config/jvm.options:/usr/share/elasticsearch/config/jvm.options  -v $PWD/data:/usr/share/elasticsearch/data  hktalent/elasticsearch:7.16.2
cd ..
cd node_data1
docker run --restart=always --ulimit nofile=65536:65536 --net esnet -p 9201:9201 -p 9301:9301 -d --name es2 -v $PWD/logs:/usr/share/elasticsearch/logs -v $PWD/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v $PWD/config/jvm.options:/usr/share/elasticsearch/config/jvm.options  -v $PWD/data:/usr/share/elasticsearch/data  hktalent/elasticsearch:7.16.2
