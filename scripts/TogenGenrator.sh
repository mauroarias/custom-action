#!/bin/bash

#
# JWT Encoder Bash Script
#

# Static header fields.
header='{
  "kid": "999999999999",
  "typ": "JWT",
  "alg": "RS256"
}'

payload='{
  "sub": "1000000000",
  "user_info": {
    "full_name": "TestFullName-0",
    "user_id": "1000000000",
    "email": "test-0@test.test",
    "username": "testUserName-0"
  },
  "scope": [],
  "iss": "https://api.unity.com/v1/oauth2",
  "exp": 2000000000,
  "iat": 1654021476,
  "jti": "o0CLelf4rEjGoXbAAEgAqeGUxrc",
  "client_id": "itest_industrial_reflect_service"
}'

base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	# Use `tr` to URL encode the output from base64.
	printf '%s' "${input}" | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

json() {
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | jq -c .
}

hmacsha256_sign()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -sha256 -binary -sign mockCert.key
}

# header_base64=$(echo "${header}" | json | base64_encode)
# payload_base64=$(echo "${payload}" | json | base64_encode)

# header_payload=$(echo -n "${header_base64}.${payload_base64}")
# signature=$(echo ${header_payload} | hmacsha256_sign | base64_encode)

# echo ${header_payload}.${signature}

cat pp
openssl dgst -sha256 -binary -sign test pp | base64_encode