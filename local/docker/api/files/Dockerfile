FROM nestjs/cli:latest
ARG API_BACKEND_DIR=project-api

# Set working dir
RUN mkdir -p /var/srv/app
WORKDIR /var/srv/app

# Set env var
ENV PATH /var/srv/app/node_modules/.bin:$PATH

# Copy dependencies files
COPY ./${API_BACKEND_DIR}/package*.json ./

# Create diocesan user, but now, we've got a 'node' user with UID 1000
# RUN adduser --disabled-password --uid 1000 --home "/var/srv/app" --gecos "Guest user to execute common binaries into the project" node

RUN apk update

RUN apk add nano

RUN npm install -g npm

RUN npm install -g typescript ts-node typeorm nodemon

RUN chown -R node:node ./

COPY ./local/docker/api/files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["docker-entrypoint"]

RUN npm install

# RUN ts-node ./node_modules/.bin/typeorm migration:run -t false

CMD [ "npm", "run", "start:dev" ]
