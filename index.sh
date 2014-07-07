#!/bin/bash

####################################################################
# @file: index.sh
# @author: Das PeTe
# @email: daspetemail@gmail.com
####################################################################

################ INCLUDES ##########################################
. includes/config.sh
. includes/urlcoder.sh


################ PARSE GET AND POST VARIABLES ######################
cgi_getvars POST ALL


################ PLACEHOLDER PARSING ###############################
parsePlaceholder


################ VARIABLES #########################################
doDownload=0


################ TELL BROWSER WE SEND AN HTML PAGE #################
printf ${initWeb}


################ SEND HTML CONSTRUCT ###############################
echo "${htmlHeader}"


################ MAIN CONTROL STRUCTURE ############################
. tasks/mainController.sh


################ CLOSE HTML CONSTRUCT ##############################
echo ${htmlFooter}