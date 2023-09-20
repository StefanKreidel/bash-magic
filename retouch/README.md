# ReTouch

Uses a specifiable EXIF metadata date and sets it as macOS filesystem creation date.

A typical use-case would be that you exported some images or videos from a tool like the macOS Photos library and the files' filesystem creation dates are now set to the export date. Or you imported files from your phone or camera and now want sort them by creation date in a tool like Davinci Resolve. These tools sometimes take the filesystem dates for sorting the files and they are always set to the import date.

## Prerequisites

[ExifTool](https://exiftool.org) has to be installed and available on the path. Check the [install instructions](https://exiftool.org/install.html) for more details.

❗ The syntax for re-`touch`-ing  (yes, the `touch` command is used) is currently **macOS specific**.

## How it works

The script loops over all files found in the `--source` folder, filters for the one which match the regex `--pattern` and sets each file's filesystem creation date to the date contained by the `--exifdata` field. The latter defaults to `CreationDate`.

## Example usage

```bash
./retouch.sh -s "/the/source/folder" -p "IMG.*\.MP4" -e CreateDate
```
