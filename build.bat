@echo off
SET CGO_ENABLED=0
SET GOOS=linux
SET GOARCH=amd64
go build -o iptest_linux_x64
SET GOOS=linux
SET GOARCH=arm
go build -o iptest_linux_arm
SET GOOS=windows
SET GOARCH=amd64
go build -o iptest_x64.exe
SET GOOS=windows
SET GOARCH=arm
go build -o iptest_win_arm.exe