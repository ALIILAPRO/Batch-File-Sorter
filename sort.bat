@echo off
setlocal enableDelayedExpansion

rem Prompt the user to select the folder they want to sort.
echo Do you want to sort the current directory (%cd%)? [Y/N]
set /p "response="
if /i "!response!"=="Y" (
    set "folderPath=%cd%"
) else (
    set /p "folderPath=Enter the path of the folder you want to sort: "
)

rem Check if the specified path exists.
if not exist "%folderPath%" (
    echo The specified path does not exist. Please try again.
    pause
    exit /b 1
)

rem Prompt the user to enter a name for the subdirectory where the sorted files will be stored.
set /p "subdirName=Enter a name for the subdirectory where the sorted files will be stored: "

rem Create a new subdirectory with the specified name.
md "%folderPath%\%subdirName%" 2>nul

rem Check if the subdirectory was created successfully.
if errorlevel 1 (
    echo Failed to create subdirectory. Please try again.
    pause
    exit /b 1
)

rem Loop through each file in the target directory.
for %%F in ("%folderPath%\*.*") do (
    rem Get the file extension.
    set "ext=%%~xF"
    
    rem If the file has an extension, move it to a corresponding subdirectory.
    if not "!ext!"=="" (
        rem Check if the current subdirectory name is equal to the folder we just created.
        if not "!ext!"=="!subdirName!" (
            rem Create a subdirectory for the current extension, if it doesn't exist.
            md "%folderPath%\%subdirName%\!ext!" 2>nul
            
            rem Check if the subdirectory was created successfully.
            if errorlevel 1 (
                echo Failed to create subdirectory. Please try again.
                pause
                exit /b 1
            )
            
            rem Move the file to the appropriate subdirectory.
            move "%%F" "%folderPath%\%subdirName%\!ext!"
            
            rem Output a message stating which file was moved to which directory.
            echo Moved "%%~nxF" to "%folderPath%\%subdirName%\!ext!\".
        )
    )
)

rem Output a final message indicating that the sorting is complete.
echo Sorting complete!
pause
