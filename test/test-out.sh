#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_deploy_release_to_artifactory() {

  # local local_ip=$(find_docker_host_ip)
  #local_ip=localhost

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"
  local folder="/generic/ecd-front"
  local version="20161109222826"
  local username="${ART_USER}"
  local password="${ART_PWD}"

  local repository="/generic/ecd-front"
  local file="ecd-front-(?<version>.*).tar.gz"

  local version=20161109222826

  deploy_without_credentials $endpoint $regex $repository $file $version $src
}

it_can_deploy_release_to_artifactory_with_credentials() {

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"

  local username="${ART_USER}"
  local password="${ART_PWD}"

  local repository="/generic/ecd-front"
  local file="ecd-front-(?<version>.*).tar.gz"

  local version=20161109222826

  deploy_with_credentials $endpoint $regex $repository $file $version $src $username $password
}

it_can_skip_redeploying_existing_release_to_artifactory() {

  # local local_ip=$(find_docker_host_ip)
  #local_ip=localhost

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"
  local folder="/generic/ecd-front"
  local version="20161109222826"
  local username="${ART_USER}"
  local password="${ART_PWD}"
  local skip_redeploy="true"

  local repository="/generic/ecd-front"
  local file="ecd-front-(?<version>.*).tar.gz"

  local version=20161109222826

  deploy_without_credentials_and_skip_redeploy $endpoint $regex $repository $file $version $src $skip_redeploy
}

run it_can_deploy_release_to_artifactory_with_credentials
run it_can_deploy_release_to_artifactory
run it_can_skip_redeploying_existing_release_to_artifactory

