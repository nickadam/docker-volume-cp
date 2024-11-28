FROM alpine

FROM alpine:3.12

RUN apk add \
  tini \
  rsync \
  openssh-client \
  openssh-server \
  openssh-sftp-server \
  openssh \
  bash \
  shadow

RUN ssh-keygen -A && \
  usermod -p '*' root && \
  ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N "" && \
  cp "$HOME/.ssh/id_rsa.pub" "$HOME/.ssh/authorized_keys"

COPY docker-entrypoint.sh /

EXPOSE 22/tcp 80/tcp

ENTRYPOINT ["tini", "./docker-entrypoint.sh"]
