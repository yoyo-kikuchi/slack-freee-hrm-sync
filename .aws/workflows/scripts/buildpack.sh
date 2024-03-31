#!/bin/bash
#------------------------------
# validate
#------------------------------
# params
readonly branch=${1:?}
readonly image_tag=${2:?}
readonly reg_name=${3:?}

# env
image_prefix=""
if [[ "${branch}" == "master"  ]]; then
  readonly image_prefix="slack-freee-hrm-sync"
fi
if [[ "${branch}" == "stg" ]]; then
  readonly image_prefix="stg-slack-freee-hrm-sync"
fi

if [[ "${image_prefix}x" == "x" ]]; then echo "${branch} branch is not supported." >&2; exit 1; fi

# dep
if [[ "$(which docker)x" == "x" ]]; then echo "docker is not installed." >&2; exit 1; fi

# Change current script dir
echo cd `dirname $0`

function buildpack() {
  local _image_name="${1:?}"

  # Change root dir
  cd ../../

  echo -e "\nbuildpack ${_image_name}" >&2
  echo -e "\n-- docker build" >&2
  docker build \
    --tag ${_image_name}:latest . || return 1

  echo -e "\n-- docker tag" >&2
  docker tag ${_image_name}:latest ${reg_name}/${_image_name}:${image_tag} || return 1
  docker tag ${_image_name}:latest ${reg_name}/${_image_name}:latest       || return 1

  echo -e "\n-- docker push" >&2
  docker push ${reg_name}/${_image_name}:${image_tag} || return 1
  docker push ${reg_name}/${_image_name}:latest       || return 1
}

#------------------------------
# main
#------------------------------
# cd
readonly wk_script_dir="$(dirname $0)"
readonly dir_repo_root="$(cd ${wk_script_dir}/..; pwd)"
cd "${dir_repo_root}" || exit 1


# buildpack
buildpack "${image_prefix}" || exit 1
