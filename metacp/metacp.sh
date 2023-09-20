#!/usr/bin/env bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--source)
      SOURCE_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -d|--destination)
      DESTINATION_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if ! command -v exiftool &> /dev/null; then
    echo "exiftool has to be installed"
    exit 1
fi

if [ -z "${SOURCE_DIR}" ] || [ "${SOURCE_DIR}" == " " ]; then
  echo "-s | --source parameter not set"
  exit 1
fi

if [ -z "${DESTINATION_DIR}" ] || [ "${DESTINATION_DIR}" == " " ]; then
  echo "-d | --destination parameter not set"
  exit 1
fi


# copy metadata from source to destination

for destination in "${DESTINATION_DIR}"/*; do
  destinationName="$(basename "$destination" | tr '[:upper:]' '[:lower:]')%"
  destinationName="${destinationName%.*}" # remove file extension
  for source in "${SOURCE_DIR}"/*; do
    sourceName="$(basename "$source" | tr '[:upper:]' '[:lower:]')"
    sourceName="${sourceName%.*}" # remove file extension
    if [ "$destinationName" == "$sourceName" ]; then
      exiftool -overwrite_original -extractEmbedded -TagsFromFile "$source" -All:All "$destination"
      echo "replaced metadata for $destinationName"
    fi
  done
done

echo ""
echo "complete"
