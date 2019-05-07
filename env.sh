#!/bin/bash

arrIN=(${npm_lifecycle_event//:/ })
command=${arrIN[0]}
env_name=${arrIN[1]}

dev_sub=${NPM_RUN_ENV_DEV_SUBSTITUTION:-development}
prod_sub=${NPM_RUN_ENV_PROD_SUBSTITUTION:-production}
local_sub=${NPM_RUN_ENV_LOCAL_SUBSTITUTION:-local}
test_sub=${NPM_RUN_ENV_TEST_SUBSTITUTION:-test}
ci_sub=${NPM_RUN_ENV_CI_SUBSTITUTION:-ci}


if [ -z $env_name ]
then
    npm run ${@:-$command}
else
    case $env_name in
        dev)
                NODE_ENV=$dev_sub && npm run ${@:-$command}
                ;;
        prod)
                NODE_ENV=$prod_sub && npm run ${@:-$command}
                ;;
        local)
                NODE_ENV=$local_sub && npm run ${@:-$command}
                ;;
        test)
                NODE_ENV=$test_sub && npm run ${@:-$command}
                ;;
        ci)
                NODE_ENV=$ci_sub && npm run ${@:-$command}
                ;;
        *)
                upper_custom=$(echo $env_name |tr [a-z] [A-Z])
                custom_sub="NPM_RUN_ENV_${upper_custom}_SUBSTITUTION"
                if [ -z ${!custom_sub} ]
                then
                    echo "No custom substitution for $env_name : You can define it in the env var NPM_RUN_ENV_${upper_custom}_SUBSTITUTION"
                else
                    echo "Found custom substitution for $env_name : ${!custom_sub}"
                    NODE_ENV=${!custom_sub} && npm run ${@:-$command}
                fi
                ;;
    esac
fi
