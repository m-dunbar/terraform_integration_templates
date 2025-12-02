#! /bin/bash
# shellcheck shell=bash
# shellcheck disable=SC2034 # ignore unused variable
# shellcheck disable=SC2154 # ignore undefined variable (colors are defined in colorize.sh)
# =============================================================================
# lib/auth.sh :: mdunbar :: 2023 sep 06
# =============================================================================
# Source lib
# --------------------
# shellcheck disable=SC1091 # ignore not following external source for colorish.sh
. ./lib/colorize.sh

function cert_expired() {
  if [[ ! -f ${HOME}/.athenz/cert ]]; then
    echo "No cert found.  Creating one now."
    return 0
  fi

  # shellcheck disable=SC2312 # ignore comparing timestamps
  [[ $(( $(date +%s) - $(date -r "${HOME}/.athenz/cert" +%s) )) -gt 3600 ]];
}

function fed() {
  local AWS_PROFILE=$1
  local ROLE=$2

  echo "Current ${cyan}AWS${normal} session has ${red}expired${normal}.  Renewing..."
  echo "connecting to AWS via: awsfed2 --account ${AWS_PROFILE} --profile=${AWS_PROFILE} --role=${AWS_ROLE} --noprompt --sts_session_duration=3600"
  awsfed2 --account "${AWS_PROFILE}" --profile="${AWS_PROFILE}" --role="${AWS_ROLE}" --noprompt --sts_session_duration=3600 || {
      # echo "awsfed2 failed.  Exiting."
      echo "Check to see if you are a member of the specified role.";
      exit 1;
  }
}

function fed_credentials_exists() {
  local AWS_PROFILE=$1
  local ROLE=$2

  if [[ ! -f ${HOME}/.aws/credentials ]]; then
    echo "No AWS credentials found.  Calling ${cyan}awsfed2${normal}."
    echo "${green}Touch yubikey if flashing...${normal}"
    if [[ "${AWS_ROLE}" == 'fed.power.user' ]]; then
      echo "role: ${yellow}fed.power.user${normal}"
    else
      echo "role: ${blue}${AWS_ROLE}${normal}"
    fi
    # echo "connecting to AWS via: awsfed2 --profile=${AWS_PROFILE} --account=${AWS_ACCT_NUM} --role=${AWS_ROLE} --sts_session_duration=3600"
    # awsfed2 --profile=${AWS_PROFILE} --account=${AWS_ACCT_NUM} --role=${AWS_ROLE} --sts_session_duration=3600
    fed "${AWS_PROFILE}" "${AWS_ROLE}"
  fi
}

function fed_expired() {
  local AWS_PROFILE=$1
  local ROLE=$2

  aws_expiration=$(aws configure get expiration --profile "${AWS_PROFILE}")

  slice="${aws_expiration:0:4}"

  # echo "Are the first 4 characters of aws_expiration integers?"
  if [[ "${slice}" =~ "could not be found" ]]; then
    echo "AWS credentials not found.  Renewing."
    fed "${AWS_PROFILE}" "${AWS_ROLE}"
  elif [[ "${slice}" =~ ^[0-9]+$ ]]; then
    aws_unix_timestamp=$(date -j -f "%Y-%m-%d %H:%M:%S" "${aws_expiration}" "+%s" 2>/dev/null)
    current_unix_timestamp=$(date +%s)

    if [[ -n "${aws_unix_timestamp}" ]]; then
      if [[ "${aws_unix_timestamp}" -lt "${current_unix_timestamp}" ]]; then
        # echo "AWS credentials have expired. Renew."
        fed "${AWS_PROFILE}" "${AWS_ROLE}"
      else
        # echo "AWS credentials are still valid. Don't renew."
        echo "Current ${cyan}AWS${normal} session is still ${green}valid${normal}."
      fi
    else
      # echo "Empty string. Renew."
      fed "${AWS_PROFILE}" "${AWS_ROLE}"
    fi
  else
    # echo "Doesn't start with an integar year. Renew."
    fed "${AWS_PROFILE}" "${AWS_ROLE}"
  fi
}

function pre_auth() {
  local AWS_PROFILE=$1
  local ROLE=$2

  if cert_expired; then
    ### yinit
    #echo yinit -touchlessSudoTime $bastion_connection_duration -touchlessSudoHosts $bastion_host
    yinit -touchlessSudoTime "${bastion_connection_duration}" -touchlessSudoHosts "${bastion_host}"
    athenz-user-cert
  else
    echo "Current ${cyan}Athenz${normal} certs are still ${green}valid${normal}."
  fi

  fed_credentials_exists "${AWS_PROFILE}" "${ROLE}"
  fed_expired "${AWS_PROFILE}" "${ROLE}"
}

# =============================================================================
