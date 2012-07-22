#BASE_DIR=/var/www/relicious/tmp/mysql_backup
TMP_DIR=/tmp
DST_DIR= /var/www/fulsat9_redmine/public/tmp

mysqldump -u root -p --tab=${TMP_DIR} --fields-terminated-by=, --fields-optionally-enclosed-by=\" --lines-terminated-by="\r\n" relicious_production
for file in ${TMP_DIR}/*.txt; do sudo mv $file ${file%.txt}.csv; done
sudo nkf -sLw --overwrite ${TMP_DIR}/*.csv
sudo tar czvf ${DST_DIR}/db_dump_test.tgz ${TMP_DIR}/*.csv

