
# How to intersect of sets and separate/duplicate outputs

## Task description

The script should:

1. connect to SVN and print the list of files from certain folder
2. connect to MySQL database, that have a table "files" and print the list of files from this table
3. script should compare the lists from 1) and 2) and print the names of files that are absent into "files" table but present into SVN
4. script should update "files" table in the database with missed files.
