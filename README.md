
```bash
docker build -t whumphrey/swish-e .
docker run -it --rm -p 80:80 -p 9001:9001 whumphrey/swish-e
```

swish-e -i file.html -u

swish-e -c conf.docs -i /var/www/html/doc/

swish-e -c /var/www/html/test/swish.config -i /var/www/html/docs/