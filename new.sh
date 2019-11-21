#! /bin/bash




# If no args exit
# Double bracket Ref: https://stackoverflow.com/a/3427931/234110
# stderr Ref: https://stackoverflow.com/a/2990533/234110
if [[ $# -eq 0 ]]; then
  echo "Design name required. Example usage $(basename -- "$0") some-name" >&2
  exit 1
fi




# Validate name
# regex Ref: https://regex101.com/r/X07IXr/1
if ! [[ "$1" =~ ^[a-zA-Z]{1}[0-9]{5}$ ]]; then
  echo "Design name invalid. First letter alphabet, followed by 5 numbers." >&2
  exit 1
fi




# Find Designer parent dir
# dirname Ref: https://stackoverflow.com/a/8426110/234110
scriptDir="$(dirname -- "$0")"
designParentDir="$scriptDir/../"
designParentDirResolved="$(cd -- "$designParentDir" && pwd)"




# Create Design dir
designDir="$designParentDirResolved/$1"

if [[ -d $designDir ]]; then
  echo ""$1" already exists, retry with some-other-name" >&2
  exit 1
else
  mkdir -p "$designDir"
fi




# Copy contents (only) of xdesign/template files
cp -r "$scriptDir/xdesign/template/." "$designDir"




# Replace xdesigntemplate with $1 in package.json
# sed Ref: https://askubuntu.com/a/76842/126417
# mac error "command a expects \ followed by text" Ref: https://stackoverflow.com/a/4247319/234110
OS=`uname`
if [ "$OS" = "Darwin" ]; then # MacOS
  sed -i '' "s/xdesigntemplate/$1/g" "$designDir/package.json"
  sed -i '' "s/xdesigntemplate/$1/g" "$designDir/readme.md"
  sed -i '' "s/xdesigntemplate/$1/g" "$designDir/.github/workflows/publish.yml"
  sed -i '' "s/xdesigntemplate/$1/g" "$designDir/src/index.scss"
else # Linux and Windows
  sed -i'' "s/xdesigntemplate/$1/g" "$designDir/package.json"
  sed -i'' "s/xdesigntemplate/$1/g" "$designDir/readme.md"
  sed -i'' "s/xdesigntemplate/$1/g" "$designDir/.github/workflows/publish.yml"
  sed -i'' "s/xdesigntemplate/$1/g" "$designDir/src/index.scss"
fi




# Create dir for screenshots
mkdir -p "$designDir/screenshots"
touch "$designDir/screenshots/thumbnail-lg.png"
touch "$designDir/screenshots/thumbnail-xs.png"




# Instructions
echo "$1 Created successfully."
echo "Next step: cd to $1 and execute ./start.sh"