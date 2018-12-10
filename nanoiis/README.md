# NanoIIS

A container for IIS apps.  
What this does is to let you mount your own app in "C:\inetpub\wwwroot"

## How to run

```docker
docker run -d -it --name webiis -p 80:80 -v c:\web:C:\inetpub\wwwroot juanheredia/nanoiis
```
