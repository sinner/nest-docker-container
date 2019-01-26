# project docker containers

Multi container docker application.

Stack: ReactJS, Node/TS Express, Postgres, Redis.

## Requirements

#### You need to have installed

- git
- docker engine (client and server) >= 17.x.x
- docker-compose >= 1.8.0

Steps to install docker [on the docker website](https://docs.docker.com/install/#cloud).

## Set Up

Before to setup environment, you must set the following host kernel param to work properly with elasticsearch

```
root@localhost$ sudo sysctl -w vm.max_map_count=262144
```

All you need to do is run:

```bash
$ git clone https://github.com/sinner/ts-docker-container.git && cd ts-docker-container ; cp local/.env.dist local/.env ; chmod u+x ./setup.sh && ./setup.sh
```

After that, you could open in your favorite IDE or Editor the backend/front directory

## Useful environment information

- ### You could add the following lines into /etc/hosts

  ```bash
  127.0.0.1       local.api.project.com
  127.0.0.1       local.web.project.com
  127.0.0.1       local.rabbit.project.com
  ```

## Redis-CLI usage

If you need review some stored data in redis, you could execute the following command:

```bash
  $ docker exec -ti project-redis redis-cli
```

## RabbitMQ usage

- First of all, Log-In with this link:
  [local.rabbit.project.com:15672](http://local.rabbit.project.com:15672)

  - user/pass: guest/guest

  If it's your first setup, please, go to 'Overview' and navigate to import definitions and upload the config, maybe, there are several backup files in queue/files/rabbit*rabbit-project*\*, please, import the last one.

After this, you can log-In with project/project123 to the web management dashboard.

- <mark> Note: If you don't have queue/rabbitmq/data directory, please, create it, to avoid permission troubles.</mark>

## Contributing

Do you find another way to improve the docker build set up?...

...well you should be aware of some docker good
[practices](https://github.com/Haufe-Lexware/docker-style-guide/blob/master/DockerCompose.md) to contributing
