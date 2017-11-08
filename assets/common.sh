
# Using jq regex so we can support groups
applyRegex_version() {
  local regex=$1
  local file=$2

  jq -n "{
  version: $(echo $file | jq -R .)
  }" | jq --arg v "$regex" '.version | capture($v)' | jq -r '.version'

}

# retrieve latest version from artifactory
# e.g url=http://your-host-goes-here:8081/artifactory/api/storage/com/acme/module/
artifactory_current_version() {
  local artifacts_url=$1

  curl $1 | jq  '[.children[].uri | ltrimstr("/")]' | jq 'sort' | jq '[.[length-1]| {version: .}]'
}

# Return all versions
artifactory_versions() {
  local artifacts_url=$1

  curl $1 | jq  '[.children[].uri | ltrimstr("/")]' | jq 'sort' | jq '[.[] | {version: .}]'
}

# return uri and version of all files
artifactory_files() {
  local artifacts_url=$1
  local regex="(?<uri>$2)"

  curl $1 | jq --arg v "$regex" '[.children[].uri | capture($v)]' | jq 'sort_by(.version)' | jq '[.[] | {uri: .uri, version: .version}]'
}

in_file_with_version() {
  local artifacts_url="$1/$3"
  local regex="(?<uri>$2)"
  local version=$3

  result=$(curl $artifacts_url | jq --arg v "$regex" '[.children[].uri| capture($v) ]'| jq '[.[] | {uri: .uri, version: .version}]')
  echo $result
}


# return the list of versions from provided version
check_version() {
  local artifacts_url=$1
  local version=$2

  result=$(artifactory_versions "$artifacts_url")
  echo $result | jq --arg v "$version" '[foreach .[] as $item ([]; $item ; if $item.version >= $v then $item else empty end)]'
}
