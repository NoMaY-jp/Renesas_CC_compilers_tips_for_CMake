@echo off

if "%1" == "" (
    cmd /c %~dpfx0 %~dp0..
    goto :EOF
)

set CMAKE=C:\Program Files\CMake\bin\cmake.exe
set TESTROOT=%~dpf1%
for /f "usebackq" %%t in (`time /t`) do set TESTSTARTTIME=%%t

echo\
echo chcp 65001
chcp 65001

call :build_folder_check tb_rx65n
call :build_folder_check rl78g23_fpb
call :build_folder_check RH850F1KM_SampleProject

rem call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex1
rem call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex2
rem call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex2xx
rem call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex3
rem call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex4
rem call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex4xx
call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex5
call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex6
call :testall_folder_check tb_rx65n renesas-rx-ccrx-toolchain-ex6xx

rem call :testall_folder_check rl78g23_fpb renesas-rl78-ccrl-toolchain-ex1
rem call :testall_folder_check rl78g23_fpb renesas-rl78-ccrl-toolchain-ex2
rem call :testall_folder_check rl78g23_fpb renesas-rl78-ccrl-toolchain-ex3
rem call :testall_folder_check rl78g23_fpb renesas-rl78-ccrl-toolchain-ex4
call :testall_folder_check rl78g23_fpb renesas-rl78-ccrl-toolchain-ex5
call :testall_folder_check rl78g23_fpb renesas-rl78-ccrl-toolchain-ex6

rem call :testall_folder_check RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex1
rem call :testall_folder_check RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex2
rem call :testall_folder_check RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex3
rem call :testall_folder_check RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex4
call :testall_folder_check RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex5
call :testall_folder_check RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex6

rem call :run tb_rx65n renesas-rx-ccrx-toolchain-ex1   abs mot
rem call :run tb_rx65n renesas-rx-ccrx-toolchain-ex2   abs mot
rem call :run tb_rx65n renesas-rx-ccrx-toolchain-ex2xx abs mot
rem call :run tb_rx65n renesas-rx-ccrx-toolchain-ex3   abs mot
rem call :run tb_rx65n renesas-rx-ccrx-toolchain-ex4   abs mot
rem call :run tb_rx65n renesas-rx-ccrx-toolchain-ex4xx elf mot
call :run tb_rx65n renesas-rx-ccrx-toolchain-ex5   abs mot
call :run tb_rx65n renesas-rx-ccrx-toolchain-ex6   abs mot
call :run tb_rx65n renesas-rx-ccrx-toolchain-ex6xx elf mot

rem call :run rl78g23_fpb renesas-rl78-ccrl-toolchain-ex1 abs mot
rem call :run rl78g23_fpb renesas-rl78-ccrl-toolchain-ex2 abs mot
rem call :run rl78g23_fpb renesas-rl78-ccrl-toolchain-ex3 abs mot
rem call :run rl78g23_fpb renesas-rl78-ccrl-toolchain-ex4 abs mot
call :run rl78g23_fpb renesas-rl78-ccrl-toolchain-ex5 abs mot
call :run rl78g23_fpb renesas-rl78-ccrl-toolchain-ex6 abs mot "p,s"

rem call :run RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex1 abs mot
rem call :run RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex2 abs mot
rem call :run RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex3 abs mot
rem call :run RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex4 abs mot
call :run RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex5 abs mot
call :run RH850F1KM_SampleProject renesas-rh850-ccrh-toolchain-ex6 abs mot "p,s"

:pass

for /f "usebackq" %%t in (`time /t`) do set TESTENDTIME=%%t

echo\
echo\
echo ####
echo PASS
echo ####
echo\
echo\
echo Started at %TESTSTARTTIME%, Completed at %TESTENDTIME%

exit

:fail

for /f "usebackq" %%t in (`time /t`) do set TESTENDTIME=%%t

echo\
echo\
echo ####
echo FAIL
echo ####
echo\
echo\
echo Started at %TESTSTARTTIME%, Aborted at %TESTENDTIME%

exit

:run

rem Ninja
echo\
echo\
mkdir %TESTROOT%\%1\build
set CMDLINE="%CMAKE%" --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE:FILEPATH=%TESTROOT%\%1\cmake\%2.cmake -S=%TESTROOT%\%1 -B=%TESTROOT%\%1\build -G Ninja -DDEBUG_RSP_FILE:BOOL=TRUE
echo %CMDLINE%
%CMDLINE%
if errorlevel 1 (
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
    goto :fail
)
set CMDLINE="%CMAKE%" --build %TESTROOT%\%1\build --config RelWithDebInfo --target all --
echo %CMDLINE%
%CMDLINE%
if errorlevel 1 (
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
    goto :fail
)
if not exist "%TESTROOT%\%1\build\%1.%3" (
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
    echo\
    echo ERROR: The following file does not exist.
    echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja\%1.%3
    goto :fail
)
if not exist "%TESTROOT%\%1\build\%1.%4" (
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
    echo\
    echo ERROR: The following file does not exist.
    echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja\%1.%4
    goto :fail
)
if not "%~5" == "p,s" goto Ninja_skip_p_s
    set CMDLINE="%CMAKE%" --no-warn-unused-cli -DEXAMPLE_ALT_OUTPUT_TYPE=1 -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE:FILEPATH=%TESTROOT%\%1\cmake\%2.cmake -S=%TESTROOT%\%1 -B=%TESTROOT%\%1\build -G Ninja -DDEBUG_RSP_FILE:BOOL=TRUE
    echo %CMDLINE%
    %CMDLINE%
    set CMDLINE="%CMAKE%" --build %TESTROOT%\%1\build --config RelWithDebInfo --target all --
    echo %CMDLINE%
    %CMDLINE%
    if errorlevel 1 (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
        goto :fail
    )
    if not exist "%TESTROOT%\%1\build\test_dep_scan_etc_c.p" (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
        echo\
        echo ERROR: The following file does not exist.
        echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2__Ninja\test_dep_scan_etc_c.p
        goto :fail
    )

    set CMDLINE="%CMAKE%" --no-warn-unused-cli -DEXAMPLE_ALT_OUTPUT_TYPE=2 -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE:FILEPATH=%TESTROOT%\%1\cmake\%2.cmake -S=%TESTROOT%\%1 -B=%TESTROOT%\%1\build -G Ninja -DDEBUG_RSP_FILE:BOOL=TRUE
    echo %CMDLINE%
    %CMDLINE%
    set CMDLINE="%CMAKE%" --build %TESTROOT%\%1\build --config RelWithDebInfo --target all --
    echo %CMDLINE%
    %CMDLINE%
    if errorlevel 1 (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
        goto :fail
    )
    if not exist "%TESTROOT%\%1\build\test_dep_scan_etc_c.s" (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
        echo\
        echo ERROR: The following file does not exist.
        echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2__Ninja\test_dep_scan_etc_c.s
        goto :fail
    )
:Ninja_skip_p_s
choice /t 3 /d y>nul
move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja>nul
echo\
echo PASS: %1.%3 is successfully built.
echo PASS: %1.%4 is successfully built.
if "%~5" == "p,s" (
    echo PASS: test_dep_scan_etc_c.p is successfully generated.
    echo PASS: test_dep_scan_etc_c.s is successfully generated.
)

rem Unix Makefile
echo\
echo\
mkdir %TESTROOT%\%1\build
set CMDLINE="%CMAKE%" --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE:FILEPATH=%TESTROOT%\%1\cmake\%2.cmake -S=%TESTROOT%\%1 -B=%TESTROOT%\%1\build -G "Unix Makefiles" -DDEBUG_RSP_FILE:BOOL=TRUE
echo %CMDLINE%
%CMDLINE%
if errorlevel 1 (
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
    goto :fail
)
set CMDLINE="%CMAKE%" --build %TESTROOT%\%1\build --config RelWithDebInfo --target all --
echo %CMDLINE%
%CMDLINE%
if errorlevel 1 (
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
    goto :fail
)
if not exist "%TESTROOT%\%1\build\%1.%3" (
    echo\
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
    echo ERROR: The following file does not exist.
    echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile\%1.%3
    goto :fail
)
if not exist "%TESTROOT%\%1\build\%1.%4" (
    echo\
    choice /t 3 /d y>nul
    move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
    echo ERROR: The following file does not exist.
    echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile\%1.%4
    goto :fail
)
if not "%~5" == "p,s" goto UnixMakefile_skip_p_s
    set CMDLINE="%CMAKE%" --no-warn-unused-cli -DEXAMPLE_ALT_OUTPUT_TYPE=1 -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE:FILEPATH=%TESTROOT%\%1\cmake\%2.cmake -S=%TESTROOT%\%1 -B=%TESTROOT%\%1\build -G "Unix Makefiles" -DDEBUG_RSP_FILE:BOOL=TRUE
    echo %CMDLINE%
    %CMDLINE%
    set CMDLINE="%CMAKE%" --build %TESTROOT%\%1\build --config RelWithDebInfo --target all --
    echo %CMDLINE%
    %CMDLINE%
    if errorlevel 1 (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
        goto :fail
    )
    if not exist "%TESTROOT%\%1\build\test_dep_scan_etc_c.p" (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
        echo\
        echo ERROR: The following file does not exist.
        echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile\test_dep_scan_etc_c.p
        goto :fail
    )

    set CMDLINE="%CMAKE%" --no-warn-unused-cli -DEXAMPLE_ALT_OUTPUT_TYPE=2 -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE:FILEPATH=%TESTROOT%\%1\cmake\%2.cmake -S=%TESTROOT%\%1 -B=%TESTROOT%\%1\build -G "Unix Makefiles" -DDEBUG_RSP_FILE:BOOL=TRUE
    echo %CMDLINE%
    %CMDLINE%
    set CMDLINE="%CMAKE%" --build %TESTROOT%\%1\build --config RelWithDebInfo --target all --
    echo %CMDLINE%
    %CMDLINE%
    if errorlevel 1 (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
        goto :fail
    )
    if not exist "%TESTROOT%\%1\build\test_dep_scan_etc_c.s" (
        choice /t 3 /d y>nul
        move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
        echo\
        echo ERROR: The following file does not exist.
        echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile\test_dep_scan_etc_c.s
        goto :fail
    )
:UnixMakefile_skip_p_s
choice /t 3 /d y>nul
move %TESTROOT%\%1\build %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile>nul
echo\
echo PASS: %1.%3 is successfully built.
echo PASS: %1.%4 is successfully built.
if "%~5" == "p,s" (
    echo PASS: test_dep_scan_etc_c.p is successfully generated.
    echo PASS: test_dep_scan_etc_c.s is successfully generated.
)

goto :EOF

:build_folder_check

if exist "%TESTROOT%\%1\build" echo ERROR: The following folder already exists:
if exist "%TESTROOT%\%1\build" echo %TESTROOT%\%1\build
if exist "%TESTROOT%\%1\build" exit

goto :EOF

:testall_folder_check

rem Ninja
if not exist "%TESTROOT%\testall\with_dbg_rspf" mkdir "%TESTROOT%\testall\with_dbg_rspf"
if exist "%TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja" echo ERROR: The following folder already exists:
if exist "%TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja" echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja
if exist "%TESTROOT%\testall\with_dbg_rspf\build_%1_%2_Ninja" exit

rem Unix Makefile
if not exist "%TESTROOT%\testall\with_dbg_rspf" mkdir "%TESTROOT%\testall\with_dbg_rspf"
if exist "%TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile" echo ERROR: The following folder already exists:
if exist "%TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile" echo %TESTROOT%\testall\with_dbg_rspf\build_%1_%2_UnixMakefile
if exist "%TESTROOT%testall\\%1_%2_UnixMakefile" exit

goto :EOF
