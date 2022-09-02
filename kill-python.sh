datee=`date +%F`
timee=`date +%T`

ip=`whoami`

if [ ! -d "$HOME/GPU_temperature_logs" ]
then
	mkdir $HOME/GPU_temperature_logs
fi

filename=$HOME/GPU_temperature_logs/${ip}_${datee}_${timee}
touch $filename

who >> $filename
date >> $filename

echo " " >> $filename
echo "time | GPU temperature | GPU memory usage" >> $filename

while true
do
	temp=`nvidia-smi | grep 'MiB / ' | cut -d ' ' -f 5 | cut -d C -f 1`
	usage=`nvidia-smi | grep 'MiB / ' | cut -d '|' -f 3 | cut -d '/' -f 1`

	echo "GPU temperature: $temp C		Usage: $usage"

	timee=`date +%T`
	echo "$timee | $temp | $usage" >> $filename

	if [[ $temp -ge 50 ]]
	then
		echo "temperature reached above 50" >> $filename
		echo "kiling python..." >> $filename

		id=`nvidia-smi | grep python | cut -d ' ' -f 15`

		if [ -z "$id" ]
		then
			id=`nvidia-smi | grep python | cut -d ' ' -f 16`
		fi

		kill -9 $id

		noti -t 'GPU temperature reached limit: $temp C' -m 'killed python'
		noti -t 'GPU temperature reached limit: $temp C' -m 'killed python' --telegram
		noti -t 'GPU temperature reached limit' -m 'killed python' -s

		echo "killed python process" >> $filename
		echo "done" >> $filename

		break
	fi

	sleep 1
done
