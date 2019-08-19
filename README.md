# blog
This blog is a static-site generated with Hugo.

## Deployment
Running
```sh
make deploy
```

To invalidate all content from CloudFront edge caches invoke
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
