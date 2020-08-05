# netcore_asp.net

Docker file to run ASP.NET Core applications

## To run  

```bash
docker run -dit --name my-net-app -p 8080:80 \
    -v /data/app/httpd.conf:/usr/local/apache2/conf/httpd.conf \
    -v /data/app/httpd-vhosts.conf:/usr/local/apache2/conf/extra/httpd-vhosts.conf  \
    -v /data/app:/usr/local/apache2/htdocs \
    -e NETCOREAPP_PATH=/usr/local/apache2/htdocs/AppApi.dll \
    juanheredia/apache-netcore \
    /run.sh
```

## Version Info

2018-11-07: First release - Apache with NetCore.

## Authors

* **Juan Carlos Heredia** - *Initial work* - [InfoInnova](https://infoinnova.net)

Mail me: [Juan Carlos Heredia](mailto:jchm@infoinnova.net)

[More about me](https://about.me/juancarlosherediamayer)
