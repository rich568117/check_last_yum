yum history|grep update  > /tmp/lastupdate
awk 'BEGIN{FS="|";OFS=","}{$1=$1; print}' /tmp/lastupdate > /tmp/lastupdate.csv
awk -F "\"*,\"*" '{print $3}' /tmp/lastupdate.csv > /tmp/lastyum.log
datum1=`date -d "$(cat /tmp/lastyum.log | head -1)" "+%s"`
datum2=`date "+%s"`

diff=$(($datum2-$datum1))

days=$(($diff/(60*60*24)))
echo $days
if [ $days == 0 ]; then
        echo "OK - Last update was run less than 30 days ago"
        exit 0
        elif [ $days -gt 30 ]; then
                echo "CRITICAL - Over 30 days since last update!"
                exit 2
        elif [ $days -lt 30 ]; then
                echo "OK - Last update was run less than 30 days ago"
                exit 0
        else
                echo "UNKNOWN - Unable to calculate last update."
                exit 1
fi
