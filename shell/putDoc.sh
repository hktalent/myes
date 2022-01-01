# -H 'Authorization: <APIKEY>'

fileName=$1
curl -H  'Content-Type: application/json' -XPUT 'http://0:9200/data_archives_attachment/_doc/1?pipeline=single_attachment' -d '
{
  "filename": "${fileName}",
  "data": "'`base64 -i ${fileName} | perl -pe 's/\n/\\n/g'`'"
}'

