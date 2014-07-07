#!/bin/bash

origIFS=${IFS}




jCall "jQuery('.downloadProgressHeader').html('Connecting to Youtube...');";

mkdir -p ${tmpDownloadDir}${currentSession}
tmpDownloadDir=${tmpDownloadDir}${currentSession}/

youtube-dl -i --no-warnings --get-id "${downloadPlaylist}" > ${tmpDownloadDir}downloadList.dat 

IFS=$'\n'

playlistIDs=($(cat ${tmpDownloadDir}downloadList.dat))
videoCount=${#playlistIDs[@]}
counter=1

for (( i=0; i < ${videoCount}; i++ )); do
	downloadID="${playlistIDs[$i]}"
	counter=$(( $i + 1 ))

	if [[ "${downloadID}" != "" ]]; then
		mkdir -p ${tmpDownloadDir}${downloadID}
		_tmpDownloadDir=${tmpDownloadDir}${downloadID}
		
		cd "${_tmpDownloadDir}";

		downloadTitle=`youtube-dl -i --no-warnings --get-filename -o "%(title)s" "${downloadID}" --restrict-filenames`

		jCall "jQuery('.downloadProgressBar').css('width','0%');"
		jCall "jQuery('.downloadProgressHeader').html('DOWNLOADING ${counter} OF ${videoCount} TRACKS');";
		jCall "jQuery('.downloadProgressText').html('Please be patient<br />this task can take a while.<br /><br />Downloading ${downloadTitle}');"

		stdbuf -oL youtube-dl -i --newline --no-warnings --audio-format=best -o "${downloadTitle}.%(ext)s" ${downloadID} |
		while IFS= read -r process; do
			if grep -q "ETA" <<< "${process}"; then
				currentProgress=`rev <<< ${process} | cut -d " " -f7 | rev`

				if [[ ${currentProgress} == "of" ]]; then
					jCall "jQuery('.downloadProgressBar').css('width','100%');"
				else
					jCall "jQuery('.downloadProgressBar').css('width','${currentProgress}');"
				fi
			fi
		done


		jCall "jQuery('.downloadProgressBar').css('width','0%');"
		jCall "jQuery('.downloadProgressHeader').html('CONVERTING ${downloadTitle} TO MP3');";
		jCall "jQuery('.downloadProgressText').html('Please be patient<br />this task can take a while.<br /><br />Converting ${downloadTitle}');"
		stdbuf -oL avconv -i "${downloadTitle}.mp4" -vn -ab 192000 -ar 44100 -ac 2 -f mp3 "${downloadTitle}.mp3" 2>&1 |
		while IFS= read -r process; do
			sleep 0.75
			counter=$(( ${counter} + 2 ))
			
			if [[ $counter -gt 80 ]]; then
				counter=80
			fi

			jCall "jQuery('.downloadProgressBar').css('width','${counter}%');"
		done


		IFS=$origIFS

		jCall "jQuery('.downloadProgressHeader').html('CLEANUP TEMP FILES');";
		rm "${downloadTitle}.mp4" #"${downloadTitle}.wav"
		mkdir -p "/var/downloads/youtube/${downloadID}"
		mv "${downloadTitle}.mp3" "/var/downloads/youtube/${downloadID}/"
		rm -rf "${_tmpDownloadDir}"

		jCall "jQuery('.downloadProgressHeader').html('${downloadTitle} IS READY TO DOWNLOAD');";
		jCall "jQuery('.readyDownloaded').append('<a class = \"ui green button\" href = \"//downloads.daspete.at/youtube/${downloadID}/${downloadTitle}.mp3\">DOWNLOAD ${downloadTitle}.mp3</a>');";
	fi
done


#cat <<< ${playlistIDs} | 
#while IFS= read -r downloadID; do
	#jCall "console.log('${downloadID}');"
#done


#downloadTitle=`youtube-dl -i --no-warnings --get-filename -o "%(title)s" "${downloadFile}" --restrict-filenames`

#mkdir -p ${tmpDownloadDir}${downloadID}
#tmpDownloadDir=${tmpDownloadDir}${downloadID}

#cd "${tmpDownloadDir}";

#jCall "jQuery('.downloadProgressHeader').html('DOWNLOADING');";
#jCall "jQuery('.downloadProgressText').html('Please be patient<br />this task can take a while.<br /><br />Downloading ${downloadTitle}';"
#stdbuf -oL youtube-dl -i --newline --no-warnings --audio-format=best -o "${downloadTitle}.%(ext)s" ${downloadFile} |
#while IFS= read -r process; do
#	if grep -q "ETA" <<< "${process}"; then
#		currentProgress=`rev <<< ${process} | cut -d " " -f7 | rev`
#
#		if [[ ${currentProgress} == "of" ]]; then
#			jCall "jQuery('.downloadProgressBar').css('width','100%');"
#		else
#			jCall "jQuery('.downloadProgressBar').css('width','${currentProgress}');"
#		fi
#	fi
#done

#jCall "jQuery('.downloadProgressBar').css('width','0%');"
#jCall "jQuery('.downloadProgressHeader').html('CONVERTING ${downloadTitle} TO MP3');";
#stdbuf -oL avconv -i "${downloadTitle}.mp4" -vn -ab 192000 -ar 44100 -ac 2 -f mp3 "${downloadTitle}.mp3" 2>&1 |
#while IFS= read -r process; do
#	sleep 0.75
#	counter=$(( ${counter} + 2 ))
#	
#	if [[ $counter -gt 80 ]]; then
#		counter=80
#	fi
#
#	jCall "jQuery('.downloadProgressBar').css('width','${counter}%');"
#done


#IFS=$origIFS


#jCall "jQuery('.downloadProgressHeader').html('CLEANUP TEMP FILES');";
#rm "${downloadTitle}.mp4" #"${downloadTitle}.wav"
#mkdir -p "/var/downloads/youtube/${downloadID}"
#mv "${downloadTitle}.mp3" "/var/downloads/youtube/${downloadID}/"
#rm -rf "${tmpDownloadDir}"


#jCall "jQuery('.downloadProgressHeader').html('${downloadTitle} IS READY TO DOWNLOAD');";
#jCall "jQuery('.downloadProgress').html('<a class = \"ui green button\" href = \"//downloads.daspete.at/youtube/${currentSession}/${downloadTitle}.mp3\">DOWNLOAD ${downloadTitle}.mp3</a>');";