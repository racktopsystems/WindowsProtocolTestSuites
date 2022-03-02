#!/bin/bash
#
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#
# Argument 1: Expression used to filter test cases. For example, "TestCategory=BVT&TestCategory=SMB311" will filter out test cases which have test category BVT and SMB311. 
# Argument 2: If set, just list all filtered test cases instead of running tests actually.

# Started as a copy of RunTestCasesByFilter.sh

InvocationPath=$(dirname "$0")

Binaries="MS-SMB2_ServerTestSuite.dll,MS-FSA_ServerTestSuite.dll"

# Filter=$1
# Filter="Name~CreateFileTestCaseS20"
# Filter="Name~Offload"
Filter="Name~BVT_Leasing_FileLeasingV2"

# DryRun=$2
DryRun=""

Cmd="$InvocationPath/RunTestCasesByBinariesAndFilter.sh \"$Binaries\" \"$Filter\" \"$DryRun\""

eval $Cmd
