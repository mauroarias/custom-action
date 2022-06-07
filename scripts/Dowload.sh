#! /bin/bash

dockerArch=linux/amd64

while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--arch)
      shift
      dockerArch=$1
      shift
      ;;
    -*|--*|*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

docker run --rm --platform "$dockerArch" -v $(pwd):/scripts mauroarias/share-qa-lib:latest /bin/cp -rf /share-qa-libs/ /scripts/