FROM alpine:3.9

RUN apk add --update --no-cache tzdata git python py-pip tzdata
RUN pip install requests -v
RUN pip install urlparse2 -v
RUN pip install github-backup -v
RUN chmod +x /srv/exec.sh
CMD ["/srv/exec.sh"]
