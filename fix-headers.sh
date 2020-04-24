#! /bin/sh

find coherencemgr -type f -exec sed -i "s/\"util.h\"/\"..\/util.h\"/g" {} \;
find customcmd -type f -exec sed -i "s/\"util.h\"/\"..\/util.h\"/g" {} \;
find membackend -type f -exec sed -i "s/\"util.h\"/\"..\/util.h\"/g" {} \;
find Sieve -type f -exec sed -i "s/\"util.h\"/\"..\/util.h\"/g" {} \;
find testcpu -type f -exec sed -i "s/\"util.h\"/\"..\/util.h\"/g" {} \;

find coherencemgr -type f -exec sed -i "s/\"memEvent.h\"/\"..\/memEvent.h\"/g" {} \;
find customcmd -type f -exec sed -i "s/\"memEvent.h\"/\"..\/memEvent.h\"/g" {} \;
find membackend -type f -exec sed -i "s/\"memEvent.h\"/\"..\/memEvent.h\"/g" {} \;
find testcpu -type f -exec sed -i "s/\"memEvent.h\"/\"..\/memEvent.h\"/g" {} \;

find coherencemgr -type f -exec sed -i "s/coherencemgr\///g" {} \;
find customcmd -type f -exec sed -i "s/customcmd\///g" {} \;
find membackend -type f -exec sed -i "s/membackend\///g" {} \;
find testcpu -type f -exec sed -i "s/testcpu\///g" {} \;

find coherencemgr -type f -exec sed -i "s/\"cacheListener.h\"/\"..\/cacheListener.h\"/g" {} \;
find Sieve -type f -exec sed -i "s/\"cacheListener.h\"/\"..\/cacheListener.h\"/g" {} \;

find coherencemgr -type f -exec sed -i "s/\"replacementManager.h\"/\"..\/replacementManager.h\"/g" {} \;
find Sieve -type f -exec sed -i "s/\"replacementManager.h\"/\"..\/replacementManager.h\"/g" {} \;

find coherencemgr -type f -exec sed -i "s/\"cacheArray.h\"/\"..\/cacheArray.h\"/g" {} \;
find Sieve -type f -exec sed -i "s/\"cacheArray.h\"/\"..\/cacheArray.h\"/g" {} \;

find coherencemgr -type f -exec sed -i "s/\"lineTypes.h\"/\"..\/lineTypes.h\"/g" {} \;
find Sieve -type f -exec sed -i "s/\"lineTypes.h\"/\"..\/lineTypes.h\"/g" {} \;

find coherencemgr -type f -exec sed -i "s/\"mshr.h\"/\"..\/mshr.h\"/g" {} \;
find coherencemgr -type f -exec sed -i "s/\"memLinkBase.h\"/\"..\/memLinkBase.h\"/g" {} \;

find customcmd -type f -exec sed -i "s/\"memEventBase.h\"/\"..\/memEventBase.h\"/g" {} \;

find membackend -type f -exec sed -i "s/\"memoryController.h\"/\"..\/memoryController.h\"/g" {} \;

sed -i "s/\"hash.h\"/\"..\/hash.h\"/g" coherencemgr/coherenceController.h
sed -i "s/\"customcmd\/customCmdMemory.h\"/\"..\/customcmd\/customCmdMemory.h\"/g" membackend/memBackendConvertor.h

sed -i "s/\"customcmd\/customOpCodeCmd.h\"/\"..\/customcmd\/customOpCodeCmd.h\"/g" membackend/extMemBackendConvertor.cc
sed -i "s/\"scratchpad.h\"/\"..\/scratchpad.h\"/g" membackend/scratchBackendConvertor.cc

sed -i "s/\"memTypes.h\"/\"..\/memTypes.h\"/g" customcmd/customCmdEvent.h
sed -i "s/\"memTypes.h\"/\"..\/memTypes.h\"/g" coherencemgr/MESI_L1.h

sed -i "s/<networkMemInspector.h>/\"networkMemInspector.h\"/g" networkMemInspector.cc
sed -i "s/<memNIC.h>/\"memNIC.h\"/g" networkMemInspector.cc
