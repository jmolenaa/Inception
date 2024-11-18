GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'
BOLD='\033[1m'

test() {
	# echo Testing curl with $1
	curl $1 2> /dev/null >/dev/null
	echo $?
}

echo -e $RED testing without ignoring self signed certificate $RESET
test "https://localhost" 
echo "-------------------------------------------------------------------------"
echo -e $GREEN testing with ignoring self signed certificate $RESET
test "-k https://localhost"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http $RESET
test "-k http://localhost"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http with port 80 specified $RESET
test "-k http://localhost:80"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http with port 443 specified $RESET
test "-k http://localhost:443"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http with port 8080 specified $RESET
test "-k http://localhost:8080"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with https with port 80 $RESET
test "-k https://localhost:80"
echo "-------------------------------------------------------------------------"
echo -e $GREEN testing with https with port 443 $RESET
test "-k https://localhost:443"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with https with port 8080 $RESET
test "-k https://localhost:8080"
echo "-------------------------------------------------------------------------"

echo Same tests but now with jmolenaa.42.fr
echo -e $RED testing without ignoring self signed certificate $RESET
test "https://jmolenaa.42.fr" 
echo "-------------------------------------------------------------------------"
echo -e $GREEN testing with ignoring self signed certificate $RESET
test "-k https://jmolenaa.42.fr"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http $RESET
test "-k http://jmolenaa.42.fr"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http with port 80 specified $RESET
test "-k http://jmolenaa.42.fr:80"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http with port 443 specified $RESET
test "-k http://jmolenaa.42.fr:443"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with http with port 8080 specified $RESET
test "-k http://jmolenaa.42.fr:8080"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with https with port 80 $RESET
test "-k https://jmolenaa.42.fr:80"
echo "-------------------------------------------------------------------------"
echo -e $GREEN testing with https with port 443 $RESET
test "-k https://jmolenaa.42.fr:443"
echo "-------------------------------------------------------------------------"
echo -e $RED testing with https with port 8080 $RESET
test "-k https://jmolenaa.42.fr:8080"
echo "-------------------------------------------------------------------------"

