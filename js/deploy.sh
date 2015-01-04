#!/bin/sh

DB_NAME=sofea_test
curl -X DELETE http://127.0.0.1:5984/$DB_NAME
cd rev; couchapp push . $DB_NAME
cd ../docs; couchapp push . $DB_NAME
cd ../by; couchapp push . $DB_NAME
