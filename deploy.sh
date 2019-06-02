#!/usr/bin/env sh
set -e
set -o pipefail

usage() {
	cat >&2 <<-'EOF'
	Usage:
	EOF
	exit 1
}

#[ "$AWS_S3_BUCKET" ] || usage
#[ "$AWS_ACCESS_KEY" ] || usage
#[ "$AWS_SECRET_KEY" ] || usage

#s3cmd sync --delete-removed -P . s3://$AWS_S3_BUCKET/
