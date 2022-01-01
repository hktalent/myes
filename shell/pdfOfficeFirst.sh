# 1 创建索引
myHost="http://127.0.0.1:9200"
# number_of_shards = 5; number_of_replicas = 1
curl  -XPUT "${myHost}/docs"

# SMTP mime e-mail
# curl -F '=(;type=multipart/alternative' \
#     -F '=plain text message' \
#     -F '= <body>HTML message</body>;type=text/html' \
#     -F '=)' -F '=@textfile.txt' ...  smtp://example.com

# 2 创建管道流 -d @filename.txt 
# -F '=@putDoc.sh;encoder=base64'
# -F "web=@index.html;type=text/html" -F "submit=OK;headers=\"X-submit-type: OK\"" 
# -F "file=@localfile;filename=nameinpost" 
# -F 'file=@"localfile";filename="nameinpost"' 
curl -H  'Content-Type: application/json' -XPUT "${myHost}/_ingest/pipeline/single_attachment" -d '
{
  "description" : "Extract attachment information",
  "processors" : [
    {
      "attachment" : {
        "field": "data",
        "indexed_chars" : -1,
        "ignore_missing" : true
      }
    }
  ]
}'

# pdf docx elsx pptx
curl -H 'Content-Type: application/json'  -XPUT "${myHost}/docs" -d '{
    "settings": {
        "index": {
            "number_of_shards": 5,
            "number_of_replicas": 1
        }
    }
}'

