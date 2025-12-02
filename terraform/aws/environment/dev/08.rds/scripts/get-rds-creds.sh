#!/bin/bash
# shellcheck disable=SC2154 # ignore undefined variables (colors are defined in colorize.sh)
# shellcheck disable=SC2312 # we don't care about obscuring return codes for our concatenated pipes
# =============================================================================
# get-content-rds-creds.sh :: mdunbar :: 2024 apr 25
# =============================================================================
# Source libs
# --------------------
# shellcheck disable=SC1091 # ignore not following external sources
. ./lib/auth.sh
. ./lib/colorize.sh

# Source global variables
# --------------------
. vars.global
# DEBUG=true

# =====================================
# Local variables
# --------------------
QUIET=false
region=${AWS_REGION}

FED_PROFILE="${target_cluster}"

# check if quiet has been specified
for arg in "$@"
do
  case ${arg} in
    -q|--quiet)
      QUIET=true
      ;;
    *)
      target_cluster=${arg}
      ;;
  esac
done

# process for target_cluster specific variables
case "${target_cluster}" in
# admin credentials
tf-integration-templates-dev-aurora)
  src_db_rds_secret=$(aws secretsmanager --profile ${account_name_dev} --region ${region} list-secrets | jq -r '.SecretList[].Name | select(test("cluster"))')
  AWS_ACCT_ID=${account_number_dev}
  FED_PROFILE="${account_name_dev}"
  ;;
tf-integration-templates-dev-mariadb)
  src_db_rds_secret=$(aws secretsmanager --profile ${account_name_dev} --region ${region} list-secrets | jq -r '.SecretList[].Name | select(test("db"))')
  AWS_ACCT_ID=${account_number_dev}
  FED_PROFILE="${account_name_dev}"
  ;;
# -- staging

# -- prod

*)  usage
    exit 3
   ;;
esac

# =====================================
# Local supporting functions
# --------------------
export AWS_PROFILE=${FED_PROFILE}

function get_credentials {
  echo "${blue}checking secrets manager for compound credentials${reset}"
  ### admin db credentials are stored in secretsmanager and are automatically rotated -- must have perms to retrieve. --> fed.power.user
  src_db_user=$(aws secretsmanager get-secret-value --region "${region}" --profile="${FED_PROFILE}" --secret-id "arn:aws:secretsmanager:${region}:${AWS_ACCT_ID}:secret:${src_db_rds_secret}" --query SecretString --output text | jq -r .username)
  src_db_pw=$(aws secretsmanager get-secret-value --region "${region}" --profile="${FED_PROFILE}" --secret-id "arn:aws:secretsmanager:${region}:${AWS_ACCT_ID}:secret:${src_db_rds_secret}" --query SecretString --output text | jq -r .password)
}

function output_credentials {
  if ${QUIET}; then
    echo "${src_db_user} ${src_db_pw}"
    return
  fi
  echo "${green}Creds for ${normal}${target_cluster}"
  echo "${green}User:     ${yellow}${src_db_user}"
  echo "${green}Password: ${yellow}${src_db_pw}"
}

# =====================================
# Main
# --------------------
# pre_auth "${FED_PROFILE}" "${AWS_ROLE}"
get_credentials
output_credentials

# =============================================================================
