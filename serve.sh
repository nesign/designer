#! /bin/bash




# If local.sh is different from designer's version throw a WARNING
# cmp Ref: https://stackoverflow.com/a/53529649/234110
# basename Ref: https://unix.stackexchange.com/a/198926/65538
LOCALSHCOMPARE="$(cmp -s $0 "../designer/xdesign/template/start.sh"; echo $?)"
if [ $LOCALSHCOMPARE -ne 0 ]; then
  echo "WARN: You might have to ##=> cp ../designer/start.sh start.sh"
fi




# If mkcert not available install it
# command Ref: https://stackoverflow.com/a/26759734/234110
# previous command success check Ref: https://askubuntu.com/a/29379/126417
if ! [ -x "$(command -v mkcert)" ]; then
  if [ -x "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    if [ $? -eq 0 ]; then
      if ! [ -x "$(command -v brew)" ]; then
        echo -e '\nexport PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH\n' | tee --append ~/.profile
        source ~/.profile
      fi
      if ! [ -x "$(command -v certutil)" ]; then
        sudo apt install libnss3-tools
        if ! [ $? -eq 0 ]; then
          echo -e "Error: sudo apt install libnss3-tools"
        fi
      fi
      brew install mkcert
      # If install unsuccessful, abort
      if [ $? -eq 0 ]; then
        echo "Installed mkcert"
      else
        echo "Unable to install mkcert, to manually install and proceed, refer https://github.com/FiloSottile/mkcert"
        exit 1
      fi
    else
      echo "Unable to install LinuxBrew, refer https://github.com/Linuxbrew/install"
    fi
  else
    echo "Unable to find curl, install curl and retry"
    exit 1
  fi
fi
# If localhost.pem not available install new certs
# Install localhost cert using mkcert
if ! [ -f "../designer/localhost.pem" ]; then
  (cd ../designer && mkcert localhost && mkcert -install)
fi



# npm Install for designer
npm --prefix ../designer i




# npm Install for design if design package.json exists
# pwd Ref: https://stackoverflow.com/a/1371283/234110
# File exists Ref: https://stackoverflow.com/a/40082454/234110
if [ -e "./package.json" ]; then
  npm i
else
  echo "WARN: Can't find package.json in ${PWD##*/}, skipping npm install."
fi




# npm start for current designer
# pass args to package.json Ref: https://github.com/npm/npm/pull/5518#issuecomment-312459196
# pass args to webpack Ref: https://webpack.js.org/guides/environment-variables/
# current dir name Ref: https://stackoverflow.com/a/1371283/234110
scriptDir="$(dirname -- "$0")"
npm --prefix ../designer start -- "${PWD##*/}"