datee=`date +%F`
timee=`date +%T`

ip=`whoami`

max=10
all_users=""

for i in `seq 0 $max`
do
        temp=`who | grep "/$i"`
        #echo $temp
        all_users+="${temp: -3}"
        #echo $all_users
done

echo $all_users

noti -t "training stared on GPU" -m "logged in users: $all_users" --telegram

if [ ! -d "$HOME/GPU_temperature_logs" ]
then
        mkdir $HOME/GPU_temperature_logs
fi

filename=$HOME/GPU_temperature_logs/${all_users}_${datee}_${timee}.txt
touch $filename

echo "logged in users: $all_users" >> $filename
date >> $filename

echo " " >> $filename
echo "time | GPU temperature | GPU memory usage" >> $filename

while true
do
        temp=`nvidia-smi | grep 'MiB / ' | cut -d ' ' -f 5 | cut -d C -f 1`
        usage=`nvidia-smi | grep 'MiB / ' | cut -d '|' -f 3 | cut -d '/' -f 1`

        echo "GPU temperature: $temp C          Usage: $usage"

        timee=`date +%T`
        echo "$timee | $temp | $usage" >> $filename

        if [[ $temp -ge 85 ]]
        then
                echo "WARNING!!! temperature reached 85 degree"
                echo "WARNING!!! temperature reached 85 degree" >> $filename

                noti -t 'WARNING!!! WARNING!!! WARNING!!!' -m 'GPU temperature is 85 C, training will be stopped at 90 C' --telegram
                #noti -t 'GPU temperature reached limit' -m 'killed python' -s

        fi

        if [[ $temp -ge 90 ]]
        then
                echo "temperature reached above 90"
                echo "kiling python..."

                echo "temperature reached above 90" >> $filename
                echo "kiling python..." >> $filename

                id=`nvidia-smi | grep python | cut -d ' ' -f 15`

                if [ -z "$id" ]
                then
                        id=`nvidia-smi | grep python | cut -d ' ' -f 16`
                fi

                kill -9 $id

                #noti -t 'GPU temperature reached limit: $temp C' -m 'killed python'
                noti -m 'python killed GPU temperature reached limit: 90 C' -t user_$ip --telegram
                #noti -t 'GPU temperature reached limit' -m 'killed python' -s

                echo "killed python process" >> $filename
                echo "done" >> $filename

                echo "python killed"

                break
        fi

        sleep 1
done
