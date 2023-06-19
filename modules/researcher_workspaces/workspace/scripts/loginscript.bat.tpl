@ECHO OFF
title Create Tunnel to Instance

:: Set variables
set vm="${RESEARCHER_WORKSPACE_NAME}-deep-learning-vm-0"
set project="${PROJECT_ID}"
set zone="${REGION}-b"
set remote_port="3389"
set local_port="3333"


:: Create a IAP tunnel between localhost and remote instance
start cmd /k gcloud beta compute start-iap-tunnel %vm% %remote_port% --local-host-port=localhost:%local_port% --zone=%zone% --project=%project%

:: Timeout to give IAP time to connect
ping -n 3 127.0.0.1 > nul

:: Create RDP connection using the local port
START c:\windows\system32\mstsc.exe /v:localhost:%local_port%