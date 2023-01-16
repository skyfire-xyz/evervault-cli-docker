# Evervault Cage Dev Server in Docker

```
docker build . -t evervault-cage
docker run --init -it -P 9999:9999 --rm evervault-cage
```
