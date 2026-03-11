#!/bin/sh
set -eu

cat <<EOF >/tmp/seaweedfs-s3.json
{
  "identities": [
    {
      "name": "prj-admin",
      "credentials": [
        {
          "accessKey": "${SEAWEEDFS_ACCESS_KEY:-seaweedfs}",
          "secretKey": "${SEAWEEDFS_SECRET_KEY:-seaweedfs-secret}"
        }
      ],
      "actions": ["Admin"]
    }
  ]
}
EOF

exec weed server \
  -dir=/data \
  -ip.bind=0.0.0.0 \
  -s3 \
  -s3.port=30034 \
  -s3.config=/tmp/seaweedfs-s3.json
