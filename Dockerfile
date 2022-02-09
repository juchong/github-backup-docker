FROM alpine:3.9

COPY exec.sh /srv/exec.sh
COPY config.json.example /srv/config/config.json.example
COPY requirements.txt /srv/requirements.txt

RUN apk add --update --no-cache tzdata git python py-pip tzdata
RUN pip install requests -v
RUN pip install github-backup && github-backup -v
RUN chmod +x /srv/exec.sh
CMD ["/srv/exec.sh"]
