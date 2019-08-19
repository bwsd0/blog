#!/usr/bin/env sh
set -e
set -o pipefail

usage() {
	cat >&2 <<-'EOF'
	error: one or more AWS credentials missing
	EOF
	exit 1
}

hugo --minify

if [ ! -d public ]; then
	echo "error: public directory missing"
	exit 1
fi

[ "$AWS_S3_BUCKET" ] || usage
[ "$AWS_ACCESS_KEY" ] || usage
[ "$AWS_SECRET_KEY" ] || usage

cd public

s3cmd sync --delete-removed -P . s3://$AWS_S3_BUCKET/

sitemap="https://${AWS_S3_BUCKET}/sitemap.xml"

curl -sSL "https://www.google.com/ping?sitemap=${sitemap}"
curl -sSL "http://www.bing.com/webmaster/ping.aspx?siteMap=${sitemap}"
