# Metadata Copy

Copies the EXIF metadata from files in a *source* folder to all files found in a *destination* folder.

This can be particularly useful if you transcoded some photos or videos but the original metadata was not copied over. A typical use-case could be compressing your phone's videos to reduce the file sizes. Most tools like Handbrake, Primere Pro or Davinci Resolve do not preserve the original metadata. The transcoded files' creation date is then set to the transcoding date which is not what you would want.

## Prerequisites

[ExifTool](https://exiftool.org) has to be installed and available on the path. Check the [install instructions](https://exiftool.org/install.html) for more details.

## How it works

This bash script loops over all files found in the `--destination` folder, searches for the "same" files int the `--source` folder and simply copies the original EXIF metadata over.

The filenames are compared case-insensitive and the file extension (.jpg, .mp4, .mkv) are ignored in both cases. This means that:
- **FILE**.mp4 matches **file**.mp4
- file.**mkv** matches file.**MOV**
- file.**jpg** matches file.**m4a** --> be careful!
- but **file**.mp4 does not match **file_01**.mp4

## Example usage

```bash
./metacp.sh -s "/the/source/folder" -d "/the/destination/folder"
```
