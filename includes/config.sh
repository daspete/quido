#!/bin/bash

####################################################################
# @file: includes/config.sh
# @author: Das PeTe
# @email: daspetemail@gmail.com
####################################################################


initWeb="Content-type:text/html\n\n"

currentSession=`date +%s%N`
tmpDownloadDir=/tmp/
#mkdir -p ${tmpDownloadDir}${currentSession}
#tmpDownloadDir=${tmpDownloadDir}${currentSession}/


################ HTML TEMPLATES ####################################
htmlHeader=$(< html/header.html)
htmlFooter=$(< html/footer.html)
htmlChooseForm=$(< html/chooseForm.html)
htmlDownloadFile=$(<html/downloadFile.html)
htmlDownloadPlaylist=$(<html/downloadPlaylist.html)

htmlTemplates=('htmlHeader' 'htmlFooter' 'htmlChooseForm')
htmlTemplatesCount=${#htmlTemplates[@]}


################ HTML PLACEHOLDER ##################################
title="QUiDO - QUick DOwnloader"

placeholders=('title' 'downloadFile' 'downloadPlaylist')
placeholderCount=${#placeholders[@]}


####################################################################
#                        ,     \    /      ,                       #
#                       / \    )\__/(     / \                      #
#                      /   \  (_\  /_)   /   \                     #
#   __________________/_____\__\@  @/___/_____\_________________   #
#   |                          |\../|                          |   #
#   |                           \VV/                           |   #
#   |                                                          |   #
#   |           DO NOT TOUCH THIS - HERE ARE DRAGONS           |   #
#   |                                                          |   #
#   |                                                          |   #
#   |__________________________________________________________|   #
#                 |    /\ /      \\       \ /\    |                #
#                 |  /   V        ))       V   \  |                #
#                 |/     `       //        '     \|                #
#                 `              V                '                #
####################################################################


################ PLACEHOLDER REPLACEMENT ###########################
function parsePlaceholder() {
	for (( i=0; i < ${placeholderCount}; i++ )); do
		holderVariable="placeholders[${i}]"
		holderContent="${placeholders[${i}]}"
		holderVariable=${!holderVariable}
		holderContent=${!holderContent}

		match='${'${holderVariable}'}'

		htmlHeader=${htmlHeader/$match/$holderContent}
		htmlFooter=${htmlFooter/$match/$holderContent}
		htmlChooseForm=${htmlChooseForm/$match/$holderContent}
		htmlDownloadFile=${htmlDownloadFile/$match/$holderContent}

	done
}


################ SIMPLE JS CALLER #################################
function jCall() {
	echo "<script>${1}</script>"
}