@ECHO OFF
SETLOCAL
:: ======================================================================================
:: === Set Variables
:: ======================================================================================
SET CURDIR=%~dp0
SET WORKSPACE_LOC=%temp%
SET TEST_SUITE_NAME=%1
SET TEST_SUITE_LOC=%CURDIR%jc_test\tests\%TEST_SUITE_NAME%
SET TEST_SUITE_CONF_LOC=%TEST_SUITE_LOC%\conf
:: ======================================================================================
:: === Setup Eclipse Tools Path
:: ======================================================================================
SET ECLIPSE_DIR=C:\Tools\eclipse
:: ======================================================================================
:START
:: ======================================================================================
echo "Preparing project specific Default configuration...."
:: ======================================================================================
timeout /t 2 /nobreak
:: copy and rename  project files
copy %TEST_SUITE_LOC%\.project_template %TEST_SUITE_LOC%\.project
copy %TEST_SUITE_LOC%\.classpath_template %TEST_SUITE_LOC%\.classpath

:: make new default trx configuration file under conf folder
mkdir %TEST_SUITE_LOC%\conf
copy .\DefaultConfiguration.trx %TEST_SUITE_CONF_LOC%\%TEST_SUITE_NAME%.trx
:: ======================================================================================
::update test suite names inside defaultRun configuration and move inside test suite folder
:: ======================================================================================
@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "INTEXTFILE=DefaultRunConfiguration.launch"
set "OUTTEXTFILE=%TEST_SUITE_NAME%.launch"
set "SEARCHTEXT=XXX"
set "REPLACETEXT=%TEST_SUITE_NAME%"

for /f "delims=" %%A in ('type "%INTEXTFILE%"') do (
    set "string=%%A"
    set "modified=!string:%SEARCHTEXT%=%REPLACETEXT%!"
    echo !modified!>>"%OUTTEXTFILE%"
)
endlocal
move .\%TEST_SUITE_NAME%.launch %TEST_SUITE_LOC%
:: ======================================================================================

:: ======================================================================================
echo "Opening Eclipse and importing Java Project...."
:: ======================================================================================
START /d"%ECLIPSE_DIR%\" eclipse.exe -nosplash -clean -data "%WORKSPACE_LOC%" -import "%TEST_SUITE_LOC%" 
timeout /t 8 /nobreak
echo "Task Completed"
goto EXIT
:END
:: ======================================================================================
:: === Error messages ===
:: ======================================================================================
:EXIT
exit
ENDLOCAL