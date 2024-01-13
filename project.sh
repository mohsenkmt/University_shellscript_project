function showmenu()
{
echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
echo '1- Get Directory and Save To Config File'
echo '2- Show List File and  Delet File'
echo '3- Show Config File and  Delet From Config File'
echo '4- Update Size File'
echo '5- Get Sensivity Of Program '
echo '6- Check Sensivity '
echo '7- Exit'
echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
echo 'Enter a Number: '
read y
	while [ -z $y ]
	do
	echo 'Invalid Input'
	echo 'ReEnter a Number'
	read y
	done
}


function getdir()
{
echo 'Enter a Directory'
echo '_____________________________________'
read x
	while  ! test -d $x
	do
	echo 'Wrong Input'
	echo 'ReEnter Directory'
	read x
	done
}


function createconfig()
{
flag=1
 if [ -f $1 ]
 then
  while read -r line
  do
	if [ "$line" == "$x" ] 
	then
	flag=0
	fi
  done <$1
 fi
	if [ $flag -eq 1 ]
	then
	echo $x >> $1
	else
	echo 'Repetitious Directory'
	fi

	if [ ! -f $1 ]
	then
 	echo 'Log Not Create'
	fi

du -s $x > $x/size.txt

if [ ! -f $x/size.txt ]
then
echo 'Size file Not Create'
fi
}



function list()
{
getdir
ls -l $x
echo '-------------------------------------'
echo '1-Delet File'
echo '2-Back To Menu'
echo '-------------------------------------'
echo 'Enter a Number'
read l
	while [ -z $l ]
	do
	echo 'Wrong Input'
	echo 'ReEnter Number'
	read l
	done
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='

while [ ! -z $l ]
do

	case $l  in
	"1")
	echo 'Enter File Name To Delet'
	read d
	rm $d
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	;;
	"2")
	break
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	;;
	*)
	echo 'Wrong Option'
	echo '-------------------------------------'
	echo '1-Delet File'
	echo '2-Back To Menu'
	echo '-------------------------------------'
	echo 'Enter a Number'
	read l
	;;
	esac
ls -l $x
echo '-------------------------------------'
echo '1-Delet File'
echo '2-Back To Menu'
echo '-------------------------------------'
echo 'Enter a Number'
read l
done
}


function delconfig()
{
echo '-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-'
cat $1
echo '-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-'
echo '1-Delet by Line'
echo '2-Delet by Name'
echo '3-Back To Menu'
echo '-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-'
echo 'Enter a Number'
read dc
	while [ -z $dc ]
	do
	echo 'Wrong Input'
	echo 'ReEnter Number'
	read dc
	done
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='

while [ ! -z $dc ]
do

	case $dc  in
	"1")
	echo 'Enter line To Delet'
	read d
	line=$(sed -n "${d}p" "$1")
	if [ -d $line ];then
	sed -i "$d d" $1
	fi
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	cat $1
	echo '-------------------------------------'
	echo '1-Delet Line'
	echo '2-Delet by Name'
	echo '3-Back To Menu'
	echo '-------------------------------------'
	echo 'Enter a Number'
	read dc
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	;;
	"2")
	echo 'Enter Name To Delet'
	read dn
	if [ -d $dn ];then
	grep -n "$dn" $1 | sed 's/:.*//' | xargs -I {} sed -i '{}d' $1
	fi
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	cat $1
	echo '-------------------------------------'
	echo '1-Delet Line'
	echo '2-Delet by Name'
	echo '3-Back To Menu'
	echo '-------------------------------------'
	echo 'Enter a Number'
	read dc
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='

	;;
	"3")
	break
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	;;
	*)
	echo 'Wrong Option'
	echo '-------------------------------------'
	cat $1
	echo '-------------------------------------'
	echo '1-Delet by Line'
	echo '2-Delet by Name'
	echo '3-Back To Menu'
	echo '-------------------------------------'
	echo 'Enter a Number'
	read dc
	;;
	esac
done
}




function updatesize()
{

 while read -r line
 do
	if [ -d $line ]
	then
 	du -s $line > $line/size.txt
	fi
 done <$1

}

function sensi()
{
sens=$(grep "Sensitivity=" "$1" | cut -d '=' -f2)
#sens=`head -n 1 $1`
while read -r line
 do
if [ -d $line ]
then
	rs=`head -n 1 $line/size.txt |awk '{print $1}'`
	rdu=$(du -s $line | awk '{print $1}')
	var=$(($rdu - $rs))
        abs_var=$(echo $var | awk '{ if ($1 < 0) {print $1 * -1} else {print $1}}')
	if [ "$sens" -lt "$abs_var" ]
	then
	echo "The Sensitivity In Dir= $line  Has Changed of = $abs_var  "
	fi
fi
 done<$1
}


function getsensi()
{
 echo ' Enter a Number to Set Sensitivity Of Program'

read n

	while [ -z $n ]
	do
	echo 'Invalid Input'
	echo 'ReEnter a Number'
	read n
	done
	if [[ $n =~ ^[0-9]+$ ]];then
		line1=`head -n 1 $1`
		if [ -d $line1 ]
		then
		sed -i "1 i Sensitivity=$n" $1
		else
		sed -i '1d' $1
		sed -i "1 i Sensitivity=$n" $1
		fi
	else
	echo 'Input Not Number'
	fi
}


#getdir
#while [ ! -z $x ]
#do
#createconfig $1
clear
showmenu

	while [ ! -z $y ]
	do
	case $y in
	"1")
	echo 'Enter a Directory'
	echo '_____________________________________'
	read x
        while  ! test -d $x
        do
        echo 'Wrong Input'
        echo 'ReEnter Directory'
        read x
        done
	createconfig $1
	showmenu
	echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
	;;
		"2")
		list
		showmenu
		echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
		;;
	"3")
	delconfig $1
	showmenu
	;;
		"4")
		updatesize $1
		showmenu
		echo '=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x='
		;;
	"5")
	getsensi $1
	showmenu
	;;
		"6")
		sensi $1
		showmenu
		;;
	"7")
	clear
	break
	;;
	*)
	echo 'Invalid Option'
	showmenu
	;;
	esac
	done
#done
