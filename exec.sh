#!/bin/sh

echo "timezone=${TIME_ZONE}"
cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
echo "${TIME_ZONE}" >/etc/timezone

echo "$(date) - start backup scheduler"
while :; do
    DATE=$(date +%Y%m%d-%H%M%S)

    for u in $(echo ${GITHUB_USER} | tr "," "\n"); do
        echo "$(date) - execute backup for ${GITHUB_USER}, ${DATE}"
        github-backup ${GITHUB_USER} --token=$TOKEN --output-directory=/srv/var/${DATE}/${u} ${OPTIONS}
    done

    echo "$(date) - cleanup"

    ls -d1 /srv/var/* | head -n -${MAX_BACKUPS} | xargs rm -rf

    echo "$(date) - sleep for 1 day"
    sleep 1d
done
