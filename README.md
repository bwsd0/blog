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

To invalidate all content from CloudFront's edge caches invoke
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

## Security and Privacy

By design this site is intended to be secure and respect user privacy
and does not contain contain  _any_ client-side Javascript, cookies or
third-party trackers.

CloudFront is configured to automatically [Redirect HTTP to
HTTPS](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-https-cloudfront-to-s3-origin.html)
and returns `HTTP 301 (Moved Permanently)` with an HTTPS URL. Note,
however, that redirection in this manner is vulnerable to MITM attack
because the initial (insecure) response headers can be intercepted by an
attacker.

A more secure alternative, is to configure CloudFront to only accept
HTTPS requests by returning an `HTTP 403 (Forbidden)` response for
non-HTTPS content. However, this is disadvantageous for sites that
formerly permitted HTTP requests and may inconvenience visitors and will
break `http` links from other sites. Yet this may also be vulnerable to
session hijacking attacks if cookies were persisted across the redirect.

Another alternative, that securely resolves HTTP requests to HTTPS is to
enable HSTS (HTTP Strict-Transport Security) by adding
`Strict-Transport-Security` to responses. At the time-of-writing this is
currently only possible using AWS Lambda@Edge functions.

### HTTP Headers

```
# Prohibit browser MIME type sniffing, and respect Content-Type headers
X-Content-Type-Options: nosniff

# Only send the referrer header for bwasd.io resources
Referrer-Policy: same-origin

# Add the Strict-Transport-Security header to all HTTPS responses
# See https://hstspreload.org/ for recommended deployment
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload

# Block site from being framed with X-Frame-Options and CSP
Content-Security-Policy: frame-ancestors 'none'
X-Frame-Options: DENY
```

### Server-Side TLS

[Modern TLS 1.3
profile](https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility)
