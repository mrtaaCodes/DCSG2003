#!/bin/bash
#Viser hvor mange brukere, posts og comments som er i databasen
#Kjøres i db1'VM-en

# Kombinert SQL-spørring uten "USE bf;"
COMBINED_QUERY="SELECT
  (SELECT COUNT(*) FROM bf.users) AS user_count,
  (SELECT COUNT(*) FROM bf.posts) AS post_count,
  (SELECT COUNT(*) FROM bf.comments) AS comment_count;"

# Kjør spørringen og vis resultat
echo "========================================"
echo " Combined Results"
echo "========================================"
cockroach sql --host=localhost:26257 --insecure --execute="$COMBINED_QUERY" | column -t
echo "========================================"
