#!/bin/bash

arrIN=(${npm_lifecycle_event//:/ })
command=${arrIN[0]}
env_name=${arrIN[1]}

dev_sub=${NPM_RUN_ENV_DEV_SUBSTITUTION:-development}
preprod_sub=${NPM_RUN_ENV_PREPROD_SUBSTITUTION:-preproduction}
prod_sub=${NPM_RUN_ENV_PROD_SUBSTITUTION:-production}
local_sub=${NPM_RUN_ENV_LOCAL_SUBSTITUTION:-local}
test_sub=${NPM_RUN_ENV_TEST_SUBSTITUTION:-test}
ci_sub=${NPM_RUN_ENV_CI_SUBSTITUTION:-ci}

if [ -z $npm_lifecycle_event ]
then
    echo "Error: run-env must be called from an npm script execution."
    echo "Exemple: "
    echo '{'
    echo '    ...'
    echo '    "scripts": {'
    echo '        "serve": "my-command app/",'
    echo '        "serve:dev": "run-env",'
    echo '        "serve:prod": "run-env",'
    echo '        "serve:custom": "run-env"'
    echo '    }'
    echo '}'
else
    if [ -z $command ]
    then
        echo "Error: No command specified"
    else
        if [ -z $env_name ]
        then
            echo "Error: No env specified"
        else
            case $env_name in
                dev)
                    echo "Running $command for environment $dev_sub"
                    NODE_ENV=$dev_sub && npm run ${@:-$command}
                    ;;
                prod)
                    echo "Running $command for environment $prod_sub"
                    NODE_ENV=$prod_sub && npm run ${@:-$command}
                    ;;
                preprod)
                    echo "Running $command for environment $preprod_sub"
                    NODE_ENV=$preprod_sub && npm run ${@:-$command}
                    ;;
                local)
                    echo "Running $command for environment $local_sub"
                    NODE_ENV=$local_sub && npm run ${@:-$command}
                    ;;
                test)
                    echo "Running $command for environment $test_sub"
                    NODE_ENV=$test_sub && npm run ${@:-$command}
                    ;;
                ci)
                    echo "Running $command for environment $ci_sub"
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
                        echo "Running $command for environment ${!custom_sub}"
                        NODE_ENV=${!custom_sub} && npm run ${@:-$command}
                    fi
                    ;;
            esac
        fi
    fi
fi
