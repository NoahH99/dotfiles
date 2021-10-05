# !/bin/sh

generate_file () {
	echo "$1$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1).png"
}

directory="$HOME/Pictures/"

if [ ! -d "$directory" ]
then
	mkdir $directory
fi

file=$(generate_file $directory)

while :
do
	if [ -f "$file" ]
	then
		file=$(generate_file $directory)
	else
		maim -u -s $file
		sleep 1
		xclip -selection clipboard -t image/png -i $file
		break
	fi
done
