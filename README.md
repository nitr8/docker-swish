
```bash
docker build -t whumphrey/swish-e .
docker run -it --rm -p 80:80 -p 9001:9001 whumphrey/swish-e
```

swish-e -i file.html -u