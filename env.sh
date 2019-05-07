#!/bin/bash
command=$npm_lifecycle_event
env_name=${command#*:}
[[ $env_name == $command ]] && env_name=""

dev_sub=${NPM_RUN_ENV_DEV_SUBSTITUTION:-developement}
prod_sub=${NPM_RUN_ENV_PROD_SUBSTITUTION:-production}
local_sub=${NPM_RUN_ENV_LOCAL_SUBSTITUTION:-local}


if [ -z $env_name ]
then
    npm run $@
else
    case $env_name in
        dev)
                NODE_ENV=$dev_sub && npm run $@
                ;;
        prod)
                NODE_ENV=$prod_sub && npm run $@
                ;;
        local)
                NODE_ENV=$local_sub && npm run $@
                ;;
        *)
                upper_custom=$(echo $env_name |tr [a-z] [A-Z])
                custom_sub="NPM_RUN_ENV_${upper_custom}_SUBSTITUTION"
                if [ -z ${!custom_sub} ]
                then
                    echo "No custom substitution for $env_name : You can define it in the env var NPM_RUN_ENV_${upper_custom}_SUBSTITUTION"
                else
                    echo "Found custom substitution for $env_name : ${!custom_sub}"
                    NODE_ENV=${!custom_sub} && npm run $@
                fi
                ;;
    esac
fi
