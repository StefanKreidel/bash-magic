#!/usr/bin/env bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -sr|--sourceRaw)
      SOURCE_RAW_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -sj|--sourceJpeg)
      SOURCE_JPEG_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -d|--destination)
      DESTINATION_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -e|--jpegExtension)
      JPEG_EXTENSION="$2"
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

if [ -z "${SOURCE_RAW_DIR}" ] || [ "${SOURCE_RAW_DIR}" == " " ]; then
  echo "-sr | --sourceRaw parameter not set"
  exit 1
fi

if [ -z "${SOURCE_JPEG_DIR}" ] || [ "${SOURCE_JPEG_DIR}" == " " ]; then
  echo "-sj | --sourceJpeg parameter not set"
  exit 1
fi

if [ -z "${DESTINATION_DIR}" ] || [ "${DESTINATION_DIR}" == " " ]; then
  echo "-d | --destination parameter not set"
  exit 1
fi

if [ -z "${JPEG_EXTENSION}" ] || [ "${JPEG_EXTENSION}" == " " ]; then
  echo "-e | --jpegExtension parameter not set, using default '.JPG'"
  JPEG_EXTENSION=".JPG"
fi


# copy raw files to destination with jpeg as filter

for jpeg in "${SOURCE_JPEG_DIR}"/*; do
  jpegName="$(basename "$jpeg" "${JPEG_EXTENSION}")"
  for raw in "${SOURCE_RAW_DIR}"/*; do
    rawFile="$(basename "$raw")"
    if [[ "$rawFile" == $jpegName* ]]; then
      echo "found jpeg for raw file ${rawFile}"
      cp "${raw}" "${DESTINATION_DIR}/${rawFile}"
    fi
  done
done

echo ""
echo "complete"
