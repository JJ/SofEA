#!/bin/sh

DB_NAME=sofea_test
cd rev; couchapp push . $DB_NAME
cd ../docs; couchapp push . $DB_NAME
cd ../by; couchapp push . $DB_NAME
