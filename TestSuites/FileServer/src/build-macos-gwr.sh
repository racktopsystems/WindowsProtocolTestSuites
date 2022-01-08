#!/bin/bash
#
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#
# Argument 1: Configuration, default value "Release".
# Argument 2: OutDir, output directory.

# I had to do a lot of hackng to get dotnet working on MacOS Big Sur
# with the proper libssl.  Also had to make links in /usr/local/lib

Configuration=""
OutDir=""
 TestSuiteRoot=/Users/gwr/wpts
InvocationPath=/Users/gwr/wpts/TestSuites/FileServer/src

export PATH=/usr/local/opt/openssl@1.1/bin:/usr/local/bin:$PATH
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export DYLD_LIBRARY_PATH="/usr/local/opt/openssl@1.1/lib:$DYLD_LIBRARY_PATH"



echo ======================================
echo          Start to build FileServer
echo ======================================

if [ -z $Configuration ]; then
    Configuration="Release"
fi

if [ -z $OutDir ]; then
    OutDir="$TestSuiteRoot/drop/TestSuites/FileServer"
fi

declare -a CommonScripts=("Get-OSVersionNumber.ps1" "Write-Error.ps1" "Write-Info.ps1")

if [ -d $OutDir -a "$OutDir" != "/" ]; then
    rm -rf $OutDir
fi

PluginDir="$OutDir/Plugin"
mkdir -p $PluginDir
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Plugin/FileServerPlugin/*.xml "$PluginDir/"

TargetDir="$PluginDir/doc"
mkdir -p $TargetDir
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Plugin/FileServerPlugin/Docs/* "$TargetDir/"

TargetDir="$PluginDir/data"
mkdir -p $TargetDir
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Plugin/FileServerPlugin/Data/* "$TargetDir/"

mkdir -p $OutDir/Batch
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Batch/*.sh $OutDir/Batch/
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Batch/*.ps1 $OutDir/Batch/
cp -f $TestSuiteRoot/common/RunTestCasesByBinariesAndFilter.* $OutDir/Batch/
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Batch/*.xsl $OutDir/Batch/

mkdir -p $OutDir/Scripts
cp -f -R $TestSuiteRoot/TestSuites/FileServer/Setup/Scripts/* $OutDir/Scripts/
for curr in "${CommonScripts[@]}"; do
    cp -f $TestSuiteRoot/CommonScripts/$curr $OutDir/Scripts/
done

mkdir -p $OutDir/Bin/Data
cp -f -R $TestSuiteRoot/TestSuites/FileServer/src/Data/* $OutDir/Bin/Data
cp -f $TestSuiteRoot/TestSuites/FileServer/src/Deploy/LICENSE.rtf $OutDir/LICENSE.rtf

Cmd="dotnet publish \"$TestSuiteRoot/TestSuites/FileServer/ShareUtil/ShareUtil.sln\" -c $Configuration -o $OutDir/Utils"

eval $Cmd

if [ $? -ne 0 ]; then
    echo "Failed to build ShareUtil tool"
    exit 1
fi

Cmd="dotnet publish \"$TestSuiteRoot/TestSuites/FileServer/src/FileServer.sln\" -c $Configuration -o $OutDir/Bin"

eval $Cmd

if [ $? -ne 0 ]; then
    echo "Failed to build FileServer test suite"
    exit 1
fi

cp -f $TestSuiteRoot/AssemblyInfo/.version $OutDir/Bin

echo ==========================================================
echo          Build FileServer test suite successfully         
echo ==========================================================
