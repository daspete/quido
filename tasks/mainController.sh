#!/bin/bash

####################################################################
# @file: tasks/mainController.sh
# @author: Das PeTe
# @email: daspetemail@gmail.com
####################################################################

if [ "${downloadFile}" != "" ]; then
	doDownload=1
	echo "${htmlDownloadFile}"
	. tasks/downloadFile.sh
fi

if [ "${downloadPlaylist}" != "" ]; then
	doDownload=1
	echo ${htmlDownloadPlaylist}
	. tasks/downloadPlaylist.sh
fi

if [ ${doDownload} == 0 ]; then
	echo "${htmlChooseForm}"
fi

