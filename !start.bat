@echo off
setlocal

set /p speedtest_count=���������ز���Э������ (Ĭ��Ϊ 5):
set /p test_option=��ѡ�����ѡ�� (1 - ��TLS, 2 - ���TLS, 3 - ͬʱ������, Ĭ��Ϊ 1):

rem ����Ĭ��ֵ
if "%speedtest_count%"=="" set "speedtest_count=5"
if "%test_option%"=="" set "test_option=1"

set "speedtest_url=speed.bestip.one/__down?bytes=50000000"
set "tcptest_url=www.bing.com" 

if "%test_option%"=="1" (
    set "test_tls=true"
    set "test_non_tls=false"
) else if "%test_option%"=="2" (
    set "test_tls=false"
    set "test_non_tls=true"
) else if "%test_option%"=="3" (
    set "test_tls=true"
    set "test_non_tls=true"
) else (
    echo ��Ч��ѡ��
    goto :error
)

:: �����������
if "%test_tls%"=="true" (
    set "tls_command=iptest.exe -speedtest=%speedtest_count% -tls=true  -url=%speedtest_url% -outfile=temp_tls_result.csv -tcpurl=%tcptest_url%"
)

if "%test_non_tls%"=="true" (
    set "non_tls_command=iptest.exe -speedtest=%speedtest_count% -tls=false  -url=%speedtest_url% -outfile=temp_non_tls_result.csv -tcpurl=%tcptest_url%"
)

:: ִ�в�������
if "%test_tls%"=="true" (
    call :RunTest "TLS" "%tls_command%"
)

if "%test_non_tls%"=="true" (
    call :RunTest "Non-TLS" "%non_tls_command%"
)

:: �ϲ���������ﱣ�ֲ��䣩
set "merge_command=type temp_tls_result.csv > merged_result.csv"
if "%test_non_tls%"=="true" (
    if exist temp_non_tls_result.csv (
        set "merge_command=%merge_command% & (for /f "usebackq skip=1 tokens=* delims=" %%a in (temp_non_tls_result.csv) do echo %%a) >> merged_result.csv"
    )
)
call %merge_command%

rem ɾ����ʱ�ļ������ﱣ�ֲ��䣩
if "%test_non_tls%"=="true" (
    if exist temp_non_tls_result.csv (
        del temp_non_tls_result.csv
    )
)

if "%test_tls%"=="true" (
    del temp_tls_result.csv
)

endlocal
goto :eof

:: �ӹ�������ִ�в�������
:RunTest
setlocal
echo ����ִ�� %~1 ����: %~2
%~2 2>nul || (
    echo %~1 ����ʱ���ִ�����鿴������Ϣ��
    goto :error
)
endlocal
goto :eof

:error
echo �ű����г��ִ�����鿴������Ϣ��
pause


