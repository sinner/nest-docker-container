ARG RABBIT_VERSION=3-management
FROM rabbitmq:${RABBIT_VERSION}

ARG WEB_USER=diocesan
ARG WEB_PASSWORD=diocesan123
ARG VHOST=diocesan
ARG CONFIG_DIR=/etc/rabbitmq
ARG RABBIT_USER=rabbitmq

VOLUME ${CONFIG_DIR}

RUN apt update > /dev/null \
  && apt install acl -y > /dev/null
RUN usermod -u 1000 ${RABBIT_USER} \
  && usermod -s /bin/bash ${RABBIT_USER} \
  && groupmod -g 1000 ${RABBIT_USER} \
  && usermod -g 1000 ${RABBIT_USER} \
  && chmod -R 664 ${CONFIG_DIR} \
  && chmod -R g+s ${CONFIG_DIR} \
  && setfacl -dR -m g:${RABBIT_USER}:rw, ${CONFIG_DIR};
  
RUN find / -user 999 -exec 2> /dev/null chown -h rabbitmq {} \; ; exit 0
RUN find / -group 999 -exec 2> /dev/null chgrp -h rabbitmq {} \; ; exit 0

# In case we need to execute some tasks before rabbitmq daemon turn on!
# COPY ./local/docker/queue/files/post_build.sh ./
# RUN chmod u+x ./post_build.sh \
# && ./post_build.sh
