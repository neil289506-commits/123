@echo off
:: 自動檢查並請求系統管理員權限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 正在請求系統管理員權限...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

echo ===================================================
echo 正在開啟 Windows 內建 WebDAV HTTP 支援...
echo ===================================================

:: 1. 修改登錄檔 BasicAuthLevel 為 2 (允許 HTTP Basic 驗證)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WebClient\Parameters" /v BasicAuthLevel /t REG_DWORD /d 2 /f

echo.
echo ===================================================
echo 正在重新啟動 WebClient 服務...
echo ===================================================

:: 2. 停止並重新啟動 WebClient 服務
net stop WebClient /y
net start WebClient

echo.
echo ===================================================
echo 設定完成！現在可以使用 Windows 檔案總管連接 WebDAV 了。
echo ===================================================
echo 帳號:walle0927 密碼:123456789 IP:100.123.101.27:32768
echo 按下enter後開啟explorer
pause
explorer
echo 三秒後退出
timeout /t 3
exit