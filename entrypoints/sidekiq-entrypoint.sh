#!/bin/sh

set -e

# Wait for MySQL
until nc -z -v -w30 $DATABASE_HOST 3306; do
 echo 'Waiting for MySQL...'
 sleep 1
done
echo "MySQL is up and running!"

# Wait for ElasticSearch
until nc -z -v -w30 $ELASTICSEARCH_URL 9200; do
 echo 'Waiting for ElasticSearch...'
 sleep 1
done
echo "ElasticSearch is up and running!"

bundle exec sidekiq