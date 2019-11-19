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




# Instructions
echo "$1 Created successfully."
echo "Next step: cd to $1 and execute ./start.sh"










exit 0




# If designer dir not available, git clone it
if [ -d "../designer" ]; then
    echo "designer exists."
else
    (cd ../ && git clone https://github.com/nesign/designer.git)
fi




# If local.sh is different from designer's version throw a WARNING
# cmp Ref: https://stackoverflow.com/a/53529649/234110
# basename Ref: https://unix.stackexchange.com/a/198926/65538
LOCALSHCOMPARE="$(cmp -s $0 "../designer/xdesign/$(basename -- "$0")"; echo $?)"
if [ $LOCALSHCOMPARE -ne 0 ]; then
  echo "WARN: $(basename -- "$0") files are different, check if you need to ##=> cp ../designer/$(basename -- "$0") $0"
fi




# If mkcert not available install it
# command Ref: https://stackoverflow.com/a/26759734/234110
# previous command success check Ref: https://askubuntu.com/a/29379/126417
if ! [ -x "$(command -v mkcert)" ]; then
  brew install mkcert
  # If install unsuccessful, abort
  if [ $? -eq 0 ]; then
    echo "Installed mkcert"
  else
    echo "Unable to install mkcert, to manually install and proceed, refer https://github.com/FiloSottile/mkcert "
    exit 1
  fi
fi
# Install localhost cert using mkcert
(cd ../designer && mkcert localhost)




# npm Install for designer
npm --prefix ../designer i




# npm Install for design if design package.json exists
# File exists Ref: https://stackoverflow.com/a/40082454/234110
if [ -e "./package.json" ]; then
  npm i
else
  echo "WARN: Can't find package.json in ${PWD##*/}, skipping npm install."
fi




# npm start for current designer
# pass args to package.json Ref: https://github.com/npm/npm/pull/5518#issuecomment-312459196
# pass args to webpack Ref: https://webpack.js.org/guides/environment-variables/
# current dir name Ref: 
npm --prefix ../designer start -- "${PWD##*/}"