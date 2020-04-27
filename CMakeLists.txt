cmake_minimum_required(VERSION 3.12)
project(memHierarchy CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# add compiler warnings
add_compile_options(-Wall -Wextra -Wpedantic)
set(INCLUDES "")
set(LIBRARIES "")

# -------------------- SST CONFIGS --------------------
execute_process(
    COMMAND which sst-config
    OUTPUT_VARIABLE SST_CONFIG
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
    COMMAND ${SST_CONFIG} --ELEMENT_CXXFLAGS
    OUTPUT_VARIABLE SST_FLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
    COMMAND ${SST_CONFIG} --ELEMENT_LDFLAGS
    OUTPUT_VARIABLE SST_LDFLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
separate_arguments(SST_FLAGS)
separate_arguments(SST_LDFLAGS)
execute_process(
    COMMAND which sst-register
    OUTPUT_VARIABLE SST_REGISTER
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

macro(_sst_compile_link _name)
    if (TARGET ${_name})
        target_compile_definitions(${_name} PRIVATE)
        target_compile_options(${_name} PRIVATE ${SST_FLAGS} ${INCLUDES})
        target_link_options(${_name} PRIVATE ${SST_LDFLAGS} ${LIBRARIES})
        execute_process(COMMAND ${SST_REGISTER} ${CMAKE_PROJECT_NAME} ${CMAKE_PROJECT_NAME}_LIBDIR=${CMAKE_CURRENT_SOURCE_DIR})
    endif ()
endmacro()

add_custom_target(
    uninstall
    COMMAND ${SST_REGISTER} -u ${CMAKE_PROJECT_NAME}
    COMMAND ${CMAKE_COMMAND} --build . --target clean --config $<CONFIG>
)
# -------------------- SST CONFIGS --------------------

# -------------------- SST EXECUTABLES --------------------
set(
    SOURCES
    cacheController.cc
    cacheFactory.cc
    bus.cc
    memoryController.cc
    memoryCacheController.cc
    coherentMemoryController.cc
    membackend/timingDRAMBackend.cc
    membackend/memBackendConvertor.cc
    membackend/simpleMemBackendConvertor.cc
    membackend/flagMemBackendConvertor.cc
    membackend/extMemBackendConvertor.cc
    membackend/delayBuffer.cc
    membackend/simpleMemBackend.cc
    membackend/simpleDRAMBackend.cc
    membackend/requestReorderSimple.cc
    membackend/requestReorderByRow.cc
    membackend/scratchBackendConvertor.cc
    membackend/simpleMemScratchBackendConvertor.cc
    memLink.cc
    memNIC.cc
    memNICFour.cc
    customcmd/amoCustomCmdHandler.cc
    directoryController.cc
    scratchpad.cc
    coherencemgr/coherenceController.cc
    memHierarchyInterface.cc
    memHierarchyScratchInterface.cc
    coherencemgr/MESI_L1.cc
    coherencemgr/MESI_Inclusive.cc
    coherencemgr/MESI_Private_Noninclusive.cc
    coherencemgr/MESI_Shared_Noninclusive.cc
    coherencemgr/Incoherent_L1.cc
    coherencemgr/Incoherent.cc
    multithreadL1Shim.cc
    mshr.cc
    testcpu/trivialCPU.cc
    testcpu/streamCPU.cc
    testcpu/scratchCPU.cc
    dmaEngine.cc
    networkMemInspector.cc
)

execute_process(
    COMMAND which sst-config
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE SST_CONFIG
)

# -------------------- COMPILE WITH EXISTING ELEMENTS --------------------
execute_process(
    COMMAND ${SST_CONFIG} merlin merlin_LIBDIR
    OUTPUT_VARIABLE merlin
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
    COMMAND ${SST_CONFIG} Messier Messier_LIBDIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE Messier
)
execute_process(
    COMMAND ${SST_CONFIG} CramSim CramSim_LIBDIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE CramSim
)
execute_process(
    COMMAND ${SST_CONFIG} ariel ariel_LIBDIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE ariel
)
execute_process(
    COMMAND ${SST_CONFIG} VaultSimC VaultSimC_LIBDIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE VaultSimC
)

if (NOT "${merlin}" STREQUAL "")
    list(APPEND INCLUDES -I${merlin})
    list(APPEND LIBRARIES -L${merlin} -lmerlin)
    list(APPEND SOURCES memNetBridge.cc)
endif ()

if (NOT "${Messier}" STREQUAL "")
    list(APPEND INCLUDES -I${Messier})
    list(APPEND LIBRARIES -L${Messier} -lMessier)
    list(APPEND SOURCES membackend/MessierBackend.cc)
endif ()

if (NOT "${CramSim}" STREQUAL "")
    list(APPEND INCLUDES -I${CramSim})
    list(APPEND LIBRARIES -L${CramSim} -lCramSim)
    list(APPEND SOURCES membackend/CramSimBackend.cc)
endif ()

if (NOT "${ariel}" STREQUAL "")
    list(APPEND INCLUDES -I${ariel})
    list(APPEND LIBRARIES -L${ariel} -lariel)
    list(APPEND SOURCES Sieve/sieveController.cc Sieve/sieveFactory.cc
        Sieve/broadcastShim.cc Sieve/memmgr_sieve.cc)
endif ()

if (NOT "${VaultSimC}" STREQUAL "")
    list(APPEND INCLUDES -I${VaultSimC})
    list(APPEND LIBRARIES -L${VaultSimC} -lVaultSimC)
    list(APPEND SOURCES membackend/vaultSimBackend.cc)
endif ()
# -------------------- COMPILE WITH EXISTING ELEMENTS --------------------


if (NOT "${DRAMSIM}" STREQUAL "")
    list(APPEND INCLUDES -I${DRAMSIM})
    list(APPEND LIBRARIES -L${DRAMSIM} -lDRAMSIM)
    execute_process(COMMAND ${SST_REGISTER} DRAMSIM DRAMSIM_LIBDIR=${DRAMSIM})
    list(APPEND SOURCES membackend/pagedMultiBackend.cc membackend/dramSimBackend.cc)
endif ()

if (NOT "${HBMDRAMSIM}" STREQUAL "")
    list(APPEND INCLUDES -I${HBMDRAMSIM})
    list(APPEND LIBRARIES -L${HBMDRAMSIM} -lHBMDRAMSIM)
    list(APPEND SOURCES membackend/HBMpagedMultiBackend.cc membackend/HBMdramSimBackend.cc)
endif ()

if (NOT "${HYBRIDSIM}" STREQUAL "")
    list(APPEND INCLUDES -I${HYBRIDSIM})
    list(APPEND LIBRARIES -L${HYBRIDSIM} -lHYBRIDSIM)
    list(APPEND SOURCES membackend/hybridSimBackend.cc)
endif ()

if (NOT "${GOBLIN_HMCSIM}" STREQUAL "")
    list(APPEND INCLUDES -I${GOBLIN_HMCSIM})
    list(APPEND LIBRARIES -L${GOBLIN_HMCSIM} -lGOBLIN_HMCSIM)
    list(APPEND SOURCES membackend/goblinHMCBackend.cc)
endif ()

if (NOT "${RAMULATOR}" STREQUAL "")
    list(APPEND INCLUDES -I${RAMULATOR})
    list(APPEND LIBRARIES -L${RAMULATOR} -lRAMULATOR)
    list(APPEND SOURCES membackend/ramulatorBackend.cc)
endif ()

if (NOT "${FDSIM}" STREQUAL "")
    list(APPEND INCLUDES -I${FDSIM})
    list(APPEND LIBRARIES -L${FDSIM} -lFDSIM)
    list(APPEND SOURCES membackend/flashSimBackend.cc)
endif ()

add_executable(
    lib${CMAKE_PROJECT_NAME}.so
    ${SOURCES}
)
_sst_compile_link(lib${CMAKE_PROJECT_NAME}.so)
# -------------------- SST EXECUTABLES --------------------
