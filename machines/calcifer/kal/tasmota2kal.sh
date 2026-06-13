mosquitto_sub -v -t 'tele/+/SENSOR' | while read topic payload
do
    grep -q Temperature <<< $payload || continue
    grep -q Humidity <<< $payload || continue
    device=${topic#*/}
    device=${device%/*}
    mosquitto_pub -t "kal/tele/$device/temperature" -m "$(echo $payload | jq '.[] | objects | .Temperature')"
    mosquitto_pub -t "kal/tele/$device/humidity" -m "$(echo $payload | jq '.[] | objects | .Humidity')"
done
