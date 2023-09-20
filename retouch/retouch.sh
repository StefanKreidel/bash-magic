#!/usr/bin/env bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--source)
      SOURCE_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -p|--pattern)
      FILE_PATTERN="$2"
      shift # past argument
      shift # past value
      ;;
    -e|--exifdata)
      EXIF_DATA="$2"
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

# check if parameters are set
if [ -z "${SOURCE_DIR}" ] || [ "${SOURCE_DIR}" == " " ]; then
  echo "-s | --source parameter not set"
  exit 1
fi

if [ -z "${FILE_PATTERN}" ] || [ "${FILE_PATTERN}" == " " ]; then
  echo "-p|--pattern parameter not set"
  exit 1
fi

if [ -z "${EXIF_DATA}" ] || [ "${EXIF_DATA}" == " " ]; then
  echo "--exifdata was set to default 'CreationDate'"
  EXIF_DATA="CreationDate"
fi


# try to navigate to source folder
cd "${SOURCE_DIR}" || echo "Source directory not found"
echo "searching in directory $(pwd)"

# update file system creation date with exif creation date
for file in `find . -maxdepth 1 -regex "\./${FILE_PATTERN}"`; do
  touch -d "$(exiftool -s -s -s -time:"${EXIF_DATA}" -d '%Y-%m-%d %H:%M:%S' "${file}")" "${file}"
  echo "updated ${file}"
done

echo ""
echo "complete"
