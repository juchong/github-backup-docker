#!/bin/sh

TIME_ZONE=${TIME_ZONE:=UTC}
echo "timezone=${TIME_ZONE}"
cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
echo "${TIME_ZONE}" >/etc/timezone

# If config doesn't exist yet, create it
if [ ! -f /srv/var/config/config.json ]; then
    cp /srv/var/config/config.json.example /srv/var/config/config.json
fi

# Update config.json
cp /srv/var/config/config.json /srv/var/config.json

# Update token in config.json match $TOKEN environment variable
sed -i '/token/c\   \"token\" : \"'${TOKEN}'\",' /srv/var/config.json

# Return config.json to persistant volume
cp /srv/var/config.json /srv/var/config/config.json

echo "$(date) - start backup scheduler"
while :; do
    DATE=$(date +%Y%m%d-%H%M%S)

    for u in $(echo $GITHUB_USER | tr "," "\n"); do
        echo "$(date) - execute backup for ${u}, ${DATE}"
        github-backup ${u} --token=$TOKEN --output-directory=/srv/var/${DATE}/${u} ${OPTIONS}
    done

    echo "$(date) - cleanup"

    ls -d1 /srv/var/* | head -n -${MAX_BACKUPS} | xargs rm -rf

    echo "$(date) - sleep for ${slptime} day"
    sleep ${slptime}
done
