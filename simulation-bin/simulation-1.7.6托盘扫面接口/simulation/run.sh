#!/bin/sh
#进入脚本文件所在目录
CURRENT_PATH=$(cd "$(dirname "$0")"; pwd)
cd $CURRENT_PATH

# Set openTCS base and home directory
export Simulation_BASE=.
export Simulation_HOME=.
#Ensure the gc log path is exist
GC_LOG_PATH=$Simulation_HOME/heap_trace.txt
if [ -d "$GC_LOG_PATH" ]; then
    echo "Gc Log path exist"
else
    touch "$GC_LOG_PATH"
fi

DUMP_LOG_PATH=$Simulation_HOME/dump
if [ -d "$DUMP_LOG_PATH" ]; then
    echo "Dump Log path exist"
else
    touch "$DUMP_LOG_PATH"
fi

# Initialize environment
export JAVA="java"
export Simulation_LIBDIR="${Simulation_BASE}/lib"
# Set the class path
export Simulation_CP="${Simulation_LIBDIR}/*"

# Start plant overview
${JAVA}  -Xms1024M                          \
    -Xmx1024M                               \
    -XX:+HeapDumpOnOutOfMemoryError         \
    -XX:HeapDumpPath="${DUMP_LOG_PATH}"     \
    -XX:+PrintGCDetails                     \
    -XX:+PrintGCTimeStamps                  \
    -XX:+PrintGCApplicationStoppedTime      \
    -Xloggc:"${GC_LOG_PATH}"     \
    -XX:+UseParallelGC                      \
    -XX:+UseParallelOldGC                   \
    -XX:-OmitStackTraceInFastThrow          \
    -classpath "${Simulation_CP}"                   \
    com.geekplus.simulation.app.Simulation