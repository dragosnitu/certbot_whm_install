#!/bin/bash

#CUSTOM_HOSTNAME=ns1.domain.com
if [ ${#CUSTOM_HOSTNAME} -lt 3 ]; then
    CUSTOM_HOSTNAME=`hostname`
    echo Hostname not specified, using $CUSTOM_HOSTNAME
else
    echo Using custom hostname $CUSTOM_HOSTNAME
fi

FILE_CERT=/etc/letsencrypt/live/$CUSTOM_HOSTNAME/cert.pem
FILE_PRIVKEY=/etc/letsencrypt/live/$CUSTOM_HOSTNAME/privkey.pem
FILE_CHAIN=/etc/letsencrypt/live/$CUSTOM_HOSTNAME/chain.pem

rawurlencode() {
  local string=`cat ${1}`
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  #REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

ENCODE_CERT=`rawurlencode $FILE_CERT`
ENCODE_PRIVKEY=`rawurlencode $FILE_PRIVKEY`
ENCODE_CHAIN=`rawurlencode $FILE_CHAIN`

/usr/sbin/whmapi1 install_service_ssl_certificate service=cpanel crt="$ENCODE_CERT" key="$ENCODE_PRIVKEY" cabundle="$ENCODE_CHAIN" && /scripts/restartsrv_cpsrvd
/usr/sbin/whmapi1 install_service_ssl_certificate service=exim crt="$ENCODE_CERT" key="$ENCODE_PRIVKEY" cabundle="$ENCODE_CHAIN" && /scripts/restartsrv_exim
/usr/sbin/whmapi1 install_service_ssl_certificate service=dovecot crt="$ENCODE_CERT" key="$ENCODE_PRIVKEY" cabundle="$ENCODE_CHAIN" && /scripts/restartsrv_dovecot
