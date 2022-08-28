while true
do
	temp=`nvidia-smi | grep 'MiB / ' | cut -d ' ' -f 5 | cut -d C -f 1`

	clear
	echo GPU temperature: $temp C

	if [[ $temp -ge 60 ]]
	then
		echo temperature reached above 60
		echo kiling python

		id=`nvidia-smi | grep python | cut -d ' ' -f 15`

		if [ -z "$id" ]
		then
			id=`nvidia-smi | grep python | cut -d ' ' -f 16`
		fi

		kill -9 $id

		noti -t 'GPU temperature reached limit' -m 'killing python'
		noti -t 'GPU temperature reached limit' -m 'killing python' --telegram
		noti -t 'GPU temperature reached limit' -m 'killing python' -s

		break
	fi

	sleep 1
done
