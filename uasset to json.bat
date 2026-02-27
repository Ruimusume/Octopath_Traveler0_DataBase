@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM -----------------------------------------------------------
REM  UAsset 转 JSON 辅助工具
REM  用法：将 .uasset 文件拖到此批处理文件上
REM  输出：在同目录生成同名 .json 文件
REM  参数：固定使用 VER_UE5_4 和 Mappings.usmap
REM -----------------------------------------------------------

REM 检查是否拖拽了文件
if "%~1"=="" (
    echo 错误：没有文件被拖入。
    echo 请将 .uasset 文件拖拽到本程序图标上。
    pause
    exit /b 1
)

REM 获取拖入文件的完整路径（支持带空格路径）
set "input_path=%~1"

REM 检查文件扩展名是否为 .uasset（不区分大小写）
if /i not "%~x1"==".uasset" (
    echo 错误：拖入的文件不是 .uasset 类型。
    echo 您拖入的是：%~nx1
    pause
    exit /b 1
)

REM 构造输出文件名：将扩展名替换为 .json
set "output_path=%~dpn1.json"

REM 检查必需的工具和映射文件是否存在
set "tool=UAssetMessagePack.exe"
set "mapping=Mappings.usmap"

if not exist "%tool%" (
    echo 错误：找不到 %tool%
    echo 请确保该工具与批处理文件在同一目录下。
    pause
    exit /b 1
)

if not exist "%mapping%" (
    echo 错误：找不到 %mapping%
    echo 请确保 %mapping% 与批处理文件在同一目录下。
    pause
    exit /b 1
)

REM 执行转换命令
echo 正在转换文件：
echo  输入：%input_path%
echo  输出：%output_path%
echo  引擎版本：VER_UE5_4
echo  映射文件：%mapping%
echo -------------------------------------------------
"%tool%" tojson "%input_path%" "%output_path%" VER_UE5_4 "%mapping%"

REM 检查命令是否执行成功
if %errorlevel% equ 0 (
    echo -------------------------------------------------
    echo 转换完成！
) else (
    echo -------------------------------------------------
    echo 转换失败，错误代码：%errorlevel%
)

pause
exit /b %errorlevel%