FROM node:carbon
ARG ADMIN_CLONED_DIRECTORY=diocesan-admin
# Set working dir
RUN mkdir -p /var/srv/app
WORKDIR /var/srv/app

# Set env var
ENV PATH /var/srv/app/node_modules/.bin:$PATH

# Copy dependencies files
COPY ./${ADMIN_CLONED_DIRECTORY}/package*.json ./
COPY ./${ADMIN_CLONED_DIRECTORY}/yarn.lock ./

# Create diocesan user, but now, we've got a 'node' user with UID 1000
#RUN adduser -D -u 1000 -g "Guest user to execute common binaries into the project" diocesan

RUN chown -R node:node ./
# Installing modules and set correct permissions
USER node

RUN yarn install


CMD [ "yarn", "start" ]
