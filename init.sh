#!/usr/bin/env bash


IGNORE_SOURCE=false
PRINT_DEBUG=true
NO_COLOR=false


venv_name="venv_estoolbox"
base_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
venv_activate_file="${base_dir}/${venv_name}/bin/activate"


NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

declare -A log_level_color
declare -A log_level_print

log_level_color[error]=$RED
log_level_color[normal]=$GREEN
log_level_color[debug]=$BLUE
log_level_color[other]=$YELLOW


function print_msg () {
	msg=$1
	level=$2

	if $NO_COLOR;then
		echo "$msg"
	else
		if [[ "$level" == "debug" ]];then
			if ! $PRINT_DEBUG;then
				return
			fi
		fi
		echo -e "${log_level_color[$level]}${msg}${NC}"
		
	fi




}


function check_venv () {

echo "$VIRTUAL_ENV" 


}




function main () {
	# Check if virtual env variable is set 
	print_msg "checking virtual env" "debug" 

	if [[ "$1" == "init" ]];then
		recursion=false
	else
		recursion=true
	fi

	if [ -z $VIRTUAL_ENV ];then
		if [ -f $venv_activate_file ];then
			print_msg "venv exists" "debug"
			source $venv_activate_file
			if [ $? -eq 0 ];then
				:

			else
				print_msg "ERROR: Failed to source venv" "error"
		fi

	else
		if $recursion;then
			print_msg "ERROR: Venv Not found, already tried to create venv" "error" 
			print_msg "ERROR: exiting" "error" 
		else
			cd $base_dir
			print_msg "Venv Not Found - Creating it" "normal"
			python3 -m venv "${base_dir}/${venv_name}"
			if [ $? -ne 0 ];then
				print_msg "ERROR: Failed to create venv" "error"
				print_msg "ERROR: exiting" "error"
			fi
			main "retry"
		fi
	fi
fi
}





if ! $IGNORE_SOURCE;then


	if [ $SHLVL -ne 1 ];then
		print_msg "Wrong usage" "error"
		print_msg "Script should be run as: \"source $0\"" "error"
		print_msg "to inherit the venv export" "error"
		exit
	fi
fi



main "init"

