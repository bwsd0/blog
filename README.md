# blog
This serverless, static-site blog generated with Hugo.

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
make post foo.md
```

To serve locally (in a container) run
```
make run
```

# License
MIT
