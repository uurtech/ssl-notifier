envup() {
  local file=$([ -z "$1" ] && echo ".env" || echo ".env.$1")

  if [ -f $file ]; then
    set -a
    source $file
    set +a
  else
    echo "No $file file found" 1>&2
    exit 1
  fi
}

envup
regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

if [ -z "$URL_LIST" ]; then
  echo "No URL supplied"
  exit 1
fi

if [ -z "$SLACK_WEBHOOK_ENDPOINT" ]; then
  echo "please provide slack webhook"
  exit 1
fi

array=($URL_LIST)

for url in "${array[@]}"; do
  if [[ $url =~ $regex ]]; then
    output=$(curl --insecure -vvI $url 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }')
    expire_date=$(echo $output | awk -F 'expire date:' '{print $2}')
    expire_date=$(echo $expire_date | awk -F ' GMT ' '{print $1}')

    todate=$(date -d "$expire_date" +'%Y%m%d')

    cond=$(date -d 'next week' +"%Y%m%d") # = 20130715
    if [ $cond -ge $todate ]; then
      curl -X POST -H 'Content-type: application/json' --data '{"text":"this $url is going to be expired"}' $SLACK_WEBHOOK_ENDPOINT
    fi

  else
    echo "$url Link not valid"
  fi
done
