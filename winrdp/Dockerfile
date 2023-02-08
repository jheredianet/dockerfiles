FROM microsoft/rdp
LABEL maintainer="@jheredianet"
EXPOSE 3389

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'SilentlyContinue'; \
    Install-WindowsFeature -Name RDS-RD-Server -IncludeManagementTools; \
    New-Item -ItemType Directory -Path "C:\Program Files\Windows NT"; \
    Set-Service -Name "TermService" -StartupType Automatic;

CMD ["powershell.exe"]
