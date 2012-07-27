user_total=`mysql -urelishuser -prelishpass relicious_production -e "select count(*) as user_total from users;"`

echo $user_total

