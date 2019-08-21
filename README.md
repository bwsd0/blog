# blog
This blog is a static-site generated with Hugo.

## Deployment
Running
```sh
make deploy
```

Invalidate all cached files CloudFront edge cache servers by invoking
```sh
make purge-cache
```

## Posting

```sh
hugo new -c ./content foo.md -k post
```

To serve locally (in a container) run
```
make run
```

# License
MIT
