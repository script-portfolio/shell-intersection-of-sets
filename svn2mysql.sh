#!/bin/bash
#

# REPOSITORY access
declare -r FOLDER='file:///usr/local/var/svn/wbal' 

# Mysql access
declare -r DBHOST='localhost'
declare -r DBNAME='TestTask'
declare -r DBUSER='user'
declare -r DBPASSWORD='userPass'
declare -r DBTABLE='files' 
declare -r FIELD='name' 

#######################################################
########################################################
# STAFF constants
declare -r REPOSITORY_PREFIX='REPOSITORY'
declare -r MYSQL_PREFIX='MYSQL'
declare -r ABSENT_PREFIX='ABSENT'
declare -r SOME_STANDART_MYSQL_PARAM=`echo -h ${DBHOST} -D ${DBNAME} \
	-u ${DBUSER} -p${DBPASSWORD}`

## we need channel (pipe for dup output - STDOUT and next pipe 
exec 5>&1
((svn list ${FOLDER} | grep -v '/$' | sed -e "s/^/${REPOSITORY_PREFIX} /")                                          && 
( mysql -B --silent ${SOME_STANDART_MYSQL_PARAM} -e "SELECT CONCAT( '${MYSQL_PREFIX} ',${FIELD}) FROM ${DBTABLE}"))  | tee /dev/fd/5 |
sort -k 2 | uniq -u -f 1 | grep  -v "^${MYSQL_PREFIX} " |  sed -e "s/^\S\+\s\(.*\)/${ABSENT_PREFIX} \1/" |             tee /dev/fd/5 | 
sed -e "s/^${ABSENT_PREFIX}\s\(.\+\)$/INSERT INTO files VALUES('\1');/" | mysql ${SOME_STANDART_MYSQL_PARAM}
