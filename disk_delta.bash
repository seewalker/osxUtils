parking="/Users/shalom/automation/freespace"
newSpace=$(df -m / | grep disk1 | awk '{print $4}')
delta=$((`cat $parking` - $newSpace))
echo $newSpace > $parking
echo $delta
