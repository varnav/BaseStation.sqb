#!/bin/bash -e

# Converts opensky aircraft database to BaseStation.sqb
# Thanks to https://rdrinfo.net/

rm -f aircraftDatabase.csv
echo "Stand by while downloading latest opensky csv file..."
#wget -q https://opensky-network.org/datasets/metadata/aircraftDatabase.csv
# See this link: https://opensky-network.org/data/aircraft
wget -q https://s3.opensky-network.org/data-samples/metadata/aircraft-database-complete-2025-02.csv -O aircraftDatabase.csv
minzize=70000000
dbsize=$(stat -c %s aircraftDatabase.csv)
printf "aircraftDatabase.csv size is %d bytes\n" $dbsize
if [ $dbsize -lt $minzize ]; then
    echo "Downloaded csv file size is smaller than $minzize"
    exit
else
    sed '3,$ {s/[^,]*/\U&/1}' aircraftDatabase.csv | sed -e '1,2d' > aircraftDatabaseu.csv
    rm -f BaseStation.sqb
    sqlite3 BaseStation.sqb < bs4dumpvdl2.sql
	rm -f aircraftDatabaseu.csv
fi
exit
