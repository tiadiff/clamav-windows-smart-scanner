@echo off
:: Richiede privilegi di amministratore
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)

title Scansione Antivirus Completa ClamAV (Modalita' Visiva)
color 0A

:: Sintassi sicura per le variabili
set "LOGFILE=%USERPROFILE%\Desktop\ClamAV_Log.txt"
set "TEMP_LOG=%USERPROFILE%\Desktop\ClamAV_Log_Temp.txt"

:: Elimina il log precedente se esiste
if exist "%LOGFILE%" del "%LOGFILE%"

:: Uso /d per garantire il cambio di unita' in ogni caso
cd /d "C:\Program Files\ClamAV"

echo[1/2] Aggiornamento del database dei virus in corso...
freshclam.exe

echo.
echo[2/2] SCANSIONE IN CORSO (Modalita' Visiva e Ottimizzata)...
echo - I file scansionati scorreranno a schermo in tempo reale
echo - Verranno ignorati i Cestini, le cartelle di sistema e i file piu' grandi di 200MB
echo.

:: Ciclo che scansiona un disco alla volta SOLO SE IL DISCO ESISTE
for %%D in (C D E F G H K L) do (
    if exist "%%D:\" (
        echo ==================================================
        echo  --^> INIZIO analisi del disco %%D:\ ...
        echo ==================================================
        
        :: Aggiunte le esclusioni per il Cestino (Regex escape) e System Volume Information
        clamscan.exe -r "%%D:\" --bell --follow-dir-symlinks=0 --follow-file-symlinks=0 --exclude-dir="D:\Giochi" --exclude-dir="G:\Skidrow" --exclude-dir="C:\MAMP" --exclude-dir="\$RECYCLE\.BIN" --exclude-dir="\$Recycle\.Bin" --exclude-dir="System Volume Information" --max-filesize=200M --max-scansize=400M --max-recursion=5 --log="%LOGFILE%" 2>nul
        
        echo  [OK] FINE analisi del disco %%D:\
        echo.
    ) else (
        echo [!] Salto il disco %%D:\ perche' non e' collegato o non esiste.
        echo.
    )
)

:: Pulizia del file di log finale
echo Scansione terminata. Pulizia del referto finale in corso...
findstr /V /I /C:"LibClamAV Warning" /C:"WARNING: Can't open file" /C:"Permission denied" /C:": OK" "%LOGFILE%" > "%TEMP_LOG%"
move /Y "%TEMP_LOG%" "%LOGFILE%" >nul

echo.
echo ==================================================
echo SCANSIONE COMPLETATA CON SUCCESSO!
echo Controlla il referto pulito in: "%LOGFILE%"
echo ==================================================

:: Emette un suono e mostra un popup
powershell -c "[console]::beep(800,400); [console]::beep(1000,600); (New-Object -ComObject Wscript.Shell).Popup('Scansione ClamAV terminata su tutti i dischi!', 0, 'Antivirus', 64)"

pause