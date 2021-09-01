
```bash
docker build -t whumphrey/swish-e .
docker run -it --rm -p 80:80 -p 9001:9001 -e ENABLE_STATS=TRUE whumphrey/swish-e
```