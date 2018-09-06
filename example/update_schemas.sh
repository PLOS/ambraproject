mysqldump -u root -h localhost --no-data -p ambra > ambra-schema.sql 
mysqldump -u root -h localhost -p ambra version |grep "INSERT" >> ambra-schema.sql 
