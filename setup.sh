#!/usr/bin/env bash

#Author: Edward Fernández B
#Date: 02/05/2018
# Description:
#   Script to clone project code and setup all enviroments (frontend/backend)
#   with docker-engine and docker-compose binaries.


# Steps:
# 1- Clone this project
# 2- Execute chmod u+x ./setup.sh && ./setup.sh

# First, clone both repositories (front/back) in current directory.
# Clone frontend and backend repositories in current directory and rename them with appropiate names
# Execute docker-compose to setup docker environment

RUN_DIRECTORY=$1;
readonly FLAGS=$1;
readonly DATE_TIME=`date +%Y%m%d_%H:%M`;
readonly LOG_FILE=$( echo $0 | cut -d'/' -f2 | head -c 13 ; echo _$DATE_TIME.log );
readonly BLOCK_FILE_NAME=".block";

getReposUrls()
{
  if [ "$FLAGS" == "devops" ];then    
    $RUN_DIRECTORY="devops";
    echo "Executing as devop mode."
  fi
  readonly BACKEND_REPOSITORY=$(cat $RUN_DIRECTORY/.env | grep -i URL_BACKEND_API_REPO | cut -d'=' -f2);
}

if [ -z "$1" ]
  then
    RUN_DIRECTORY='local';
fi

blockProcess()
{
  echo "1" > $BLOCK_FILE_NAME;
}

unBlockProcess()
{
  echo "0" > $BLOCK_FILE_NAME;
}

# 1st param is the message to log file.
# 2nd param is to know if we need to put the message to stdout.
exceptions()
{
  if [ -n "$2" ] && [ "$2" -eq 1 ];then
    echo $1;
  fi

  echo $1 >> $LOG_FILE;
  unBlockProcess;
}

switchDockerComposeFiles()
{
  find . 2>&1 -type f -name 'docker-compose.yml' | grep -v 'find:' > /dev/null;

  return $?;
}

containersUp()
{
  local _dockerEngineBinary=$(which docker);
  local _dockerComposeBinary=$(which docker-compose);
  local _cpBinary=$(which cp);

  if [ -z $_dockerEngineBinary ] || [ -z $_dockerComposeBinary ];then
    exceptions "Please, install docker and docker-compose in your system." 1; exit 1;
  fi

  echo "-- Going up containers --"

  cd $RUN_DIRECTORY;
  
  echo "-- Deploy directory: $(pwd) --";

  switchDockerComposeFiles;

  if [ "$?" -eq 0 ];then
    $_dockerComposeBinary up -d --build;
  elif [ "$?" -eq 1 ];then
    echo "Copy docker-compose .dist to .yml";
    $_cpBinary docker-compose.yml.dist docker-compose.yml \
    && $_dockerComposeBinary up -d --build;
  fi

  cd ..;

}

verifyIfExistDevDirs()
{
  _projectDirectories='project-*';

  find . 2>&1 -type d -name "$_projectDirectories" | grep -v 'find:' > /dev/null;
  _result=$?;

  if [ "$_result" -eq 0 ];then
   return 0;
  fi

  return 1;
}

cloneFrontendAndBackend()
{
  local _webProjectirectory="project-web";
  local _apiDirectory="project-api";
  local _cpBinary=$(which cp);
  
  verifyIfExistDevDirs;

  echo "-- Starting if clonning is necessary $(pwd) --";

  # $1 clone $WEB_REPOSITORY $_webProjectirectory \
  #  && $1 clone $BACKEND_REPOSITORY $_apiDirectory;
  if [ ! -d "$_apiDirectory" ]; then
    echo "-- Cloning API Repository --"
    $1 clone $BACKEND_REPOSITORY $_apiDirectory;
  else
    echo "-- It looks like the repository is already cloned --"
  fi

  if [ $? != 0 ];then
    exceptions "There was a problem related to repositories clone tasks" 1; exit 1;
  fi

  if [ ! -f "$_apiDirectory/.env" ];then
    echo "-- Copying API Environment File $_apiDirectory (.env)  --"
    cd $_apiDirectory;
    $_cpBinary .env.dist .env; 
    if [ `$1 branch | grep develop` ]; then
      $1 checkout develop;
    fi
    cd ..;
  fi

  echo "-- Finishing clonning process $(pwd) --";

  return 0;

}

clone()
{
  local _gitBinary=$(which git);

  case $? in
    0)
      cloneFrontendAndBackend $_gitBinary;
      ;;
    1)
      exceptions "Please, install GIT package in your system." 1; exit 1;
      ;;
  esac

}

run()
{
  blockProcess;
  getReposUrls $FLAGS;
  verifyIfExistDevDirs;
  echo "-- INIT: $(pwd) --";
  case $? in
    0)
      clone && containersUp;
      ;;
    1)
      clone && containersUp;
      ;;
  esac
  unBlockProcess;
}

blockStatus=`cat $BLOCK_FILE_NAME`;

case $blockStatus in
  0)
    run;
    ;;
  1)
    exceptions "Blocked process in runtime. [$DATE_TIME]" 1; exit 1;
    ;;
esac
