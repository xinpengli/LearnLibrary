@echo off
rem
rem Start the Simulation plant overview client.
rem

rem Set window title
title Simulation

rem Don't export variables to the parent shell
setlocal

rem Set IV base and home directory
set Simulation_BASE=.
set Simulation_HOME=.


set JAVA=java

rem Set base directory names.
set Simulation_CONFIGDIR=%Simulation_HOME%\config
set Simulation_LIBDIR=%Simulation_BASE%\lib

rem Set the class path
set Simulation_CP=%Simulation_LIBDIR%\*;

rem Start plant overview
start /b %JAVA%  -Xms1024M^
    -Xmx1024M^
    -XX:+UseParallelGC^
    -XX:+UseParallelOldGC^
    -XX:-OmitStackTraceInFastThrow^
    -classpath "%Simulation_CP%"^
    com.geekplus.simulation.app.Simulation