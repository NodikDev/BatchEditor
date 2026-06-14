@echo off
chcp 65001
cls
:mm
title BatchEditor
cls
echo Main Menu
echo.
echo 1.Create\Open file
echo.
echo 2.Guides
echo.
set /p menu=Write the number:
if "%menu%"=="1" goto create
if "%menu%"=="2" goto guide
goto mm

:create
cls
set "create="
set "filename="
set /p "create=Write folder name(Example: C:\Users\%username%\Desktop): "
if "%create%"=="" goto mm
echo.
set /p "filename=Write file name(Example: Text Document.txt): "
if "%filename%"=="" goto mm
set "full_path=%create%\%filename%"
set "line_num=1"

:editor
cls
if not exist "%full_path%" type nul > "%full_path%"
title %filename% - BatchEditor
set "next_line=1"
set "prev_line=0"
if exist "%full_path%" (
    for /f "tokens=1* delims=[]" %%a in ('find /n /v "" ^<"%full_path%"') do (
        echo %%a ^| %%b
        set "prev_line=%%a"
        set /A "next_line=%%a+1"
    )
)
if exist "%full_path%" if "%prev_line%"=="0" (
    set "prev_line=1"
    set "next_line=2"
)
set "input_line="
set /p "input_line=%next_line% | "
if "%input_line%"=="" goto delete_last_line
echo|set /p="%input_line%">>"%full_path%"
echo.>>"%full_path%"
goto editor

:delete_last_line
if "%prev_line%"=="0" goto editor
if not exist "%full_path%" goto editor
if "%prev_line%"=="1" (
    del "%full_path%"
    goto editor
)
if exist "%full_path%.tmp" del "%full_path%.tmp"
for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%full_path%"') do (
    if not "%%a"=="%prev_line%" (
        echo %%b>>"%full_path%.tmp"
    )
)
if exist "%full_path%.tmp" (
    move /y "%full_path%.tmp" "%full_path%" >nul
)
goto editor

:guide
cls
echo Guides
echo.
echo 1.About
echo.
echo 2.Personalisation
echo.
echo 3.Hot keys
echo.
echo 4.Go to Main Menu
echo.
set /p guide=Write the number:
if "%guide%"=="1" goto about
if "%guide%"=="2" goto pers
if "%guide%"=="3" goto keys
if "%guide%"=="4" goto mm
goto guide

:about
set "msg_text=About%%0Abold; BatchEditor Ver.0.1a%%0ACurrent User: %username%"
mshta vbscript:Execute("msgbox ""BatchEditor Ver.0.1a"" & vbcrlf & ""Current User: %username%"", 64, ""About"":close")
cls
goto guide

:keys
cls
echo Hot keys
echo.
echo Enter + text = next line + save
echo.
echo Enter + empty line = delete previous and empty line
echo.
echo Press any key to go back
pause >nul
goto guide

:pers
cls
echo Personalisation
echo.
echo Right-click on the title bar and choose Properties.
echo.
echo Press any key to go back
pause >nul
goto guide
