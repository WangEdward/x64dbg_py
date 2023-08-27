#!/bin/bash


X64DBGPY_LATEST_TAG=$(curl --silent "https://api.github.com/repos/x64dbg/x64dbgpy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [[ "$X64DBGPY_LATEST_TAG" != "8c0538a" ]]; then echo "Error: x64dbgpy version is not 8c0538a"; exit 1; fi


mkdir -p working_dir
cd working_dir

pwd


# Download and unzip x64dbg
wget https://sourceforge.net/projects/x64dbg/files/latest/download -O x64dbg.zip
unzip x64dbg.zip -d x64dbg




# Download and install x64dbgpy
wget https://github.com/x64dbg/x64dbgpy/releases/download/8c0538a/x64dbgpy_8c0538a.zip -O x64dbgpy.zip
unzip x64dbgpy.zip -d x64dbg/release


# https://github.com/x64dbg/mona

# Download mona.py and pykd.py from GitHub
wget https://github.com/corelan/mona/raw/master/mona.py
wget https://github.com/x64dbg/x64dbgpylib/raw/master/pykd.py
wget https://github.com/x64dbg/x64dbgpylib/raw/master/x64dbgpylib.py

X64DBG_COMMIT_HASH=$(cat x64dbg/commithash.txt)
MONA_REVISION=$(grep -m1 -oP '\$Revision:\s*\K\d+' mona.py)
PYKD_VERSION=$(grep -oP 'version = "\K[^"]+' pykd.py)
X64DBGPYLIB_REVISION=$(grep -m1 -oP '\$Revision:\s*\K\d+' x64dbgpylib.py)

cp *.py x64dbg/release/x32/plugins/x64dbgpy/
cp *.py x64dbg/release/x64/plugins/x64dbgpy/

# write version info
echo "X64DBG_COMMIT_HASH=$X64DBG_COMMIT_HASH" >> x64dbg/version.txt
echo "X64DBGPY_LATEST_TAG=$X64DBGPY_LATEST_TAG" >> x64dbg/version.txt
echo "MONA_REVISION=$MONA_REVISION" >> x64dbg/version.txt
echo "PYKD_VERSION=$PYKD_VERSION" >> x64dbg/version.txt
echo "X64DBGPYLIB_REVISION=$X64DBGPYLIB_REVISION" >> x64dbg/version.txt

export VERSION_HASH=$(sha256sum x64dbg/version.txt | awk '{ print $1 }')