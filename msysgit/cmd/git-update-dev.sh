#!/bin/sh

/share/msysGit/initialize.sh

cd /

git fetch origin
git checkout devel
git pull origin devel

echo 開始更新 /git (devel)...
cd git

git fetch origin
git checkout devel
git pull origin devel

clear
echo ...更新結束.

echo 開始編譯...

make

clear
echo ...編譯結束.

#/share/msysGit/run-tests.sh

#cd /git/t
#sh t7200-* -i -v
#sh -x t7200-* -i -v

/cmd/git-version.sh
