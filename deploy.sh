#!/bin/bash
set -e
set -o pipefail

# FIXME: The Makfile which invokes this script fails to pass these environment
# variables to the shell process so they need to be set manually.
AWS_S3_BUCKET="blog.bwasd.io"
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""

usage() {
	cat >&2 <<-'EOF'
	error: one or more AWS credentials missing
	EOF
	exit 1
}

[ "$AWS_S3_BUCKET" ] || usage
[ "$AWS_ACCESS_KEY" ] || usage
[ "$AWS_SECRET_KEY" ] || usage


{ \
	echo '[default]'; \
	echo "access_key="$AWS_ACCESS_KEY""; \
	echo "secret_key="$AWS_SECRET_KEY""; \
} > ~/.s3cfg

hugo --minify

if [ ! -d public ]; then
	echo "error: public directory missing"
	exit 1
fi

cd public

s3cmd sync --delete-removed -P . s3://$AWS_S3_BUCKET/

sitemap="https://${AWS_S3_BUCKET}/sitemap.xml"

curl -sSL "https://www.google.com/ping?sitemap=${sitemap}"
curl -sSL "https://www.bing.com/webmaster/ping.aspx?siteMap=${sitemap}"
