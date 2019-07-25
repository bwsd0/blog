# blog

## Deployment

```bash
make
```

## TODO

### Security

#### Web Security

```
# Prevent browsers from MIME type sniffing, and respect Content-Type headers
X-Content-Type-Options: nosniff

# only send the referrer header for bwasd.io resources (bwasd.com excluded)
Referrer-Policy: same-origin

# Add the Strict-Transport-Security header to all HTTPS responses
# See https://hstspreload.org/ for recommended deployment
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload

# Block site from being framed with X-Frame-Options and CSP
Content-Security-Policy: frame-ancestors 'none'
X-Frame-Options: DENY
```

### Server-Side TLS

[Modern TLS 1.3 profile](https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility)
