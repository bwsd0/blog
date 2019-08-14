# blog

This blog is a static-site generated with Hugo.

## Deployment

Running
```sh
make deploy
```
processes all markup, images and style-sheets under the `content`
directory and uploads to an S3 bucket and delivered (cached) by
CloudFront.

To invalidate all content from CloudFront edge caches invoke
```sh
make purge-cache
```

## Posting

The following creates a post
```sh
hugo new -c ./content foo.{md,rst} -k post
```

To serve locally (in a container) run
```
make run
```

# License

MIT
