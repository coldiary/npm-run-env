# npm-run-env

A small NPM script-runner to easily substitute NODE_ENV from npm scripts name

## Installation

```sh
# Install it either globally
npm i -g npm-run-env

# Or locally in your project
npm i --save npm-run-env
```

## Usage

This utility is used to substitute NODE_ENV variable in NPM scripts like :

```
{
  "scripts": {
    "serve": "my-command app/",
    "serve:dev": "NODE_ENV=development my-command app/",
    "serve:prod": "NODE_ENV=production my-command app/",
    "serve:custom": "NODE_ENV=some_custom_env my-command app/"
  }
}
```

in order to only have to write :

```
{
  "scripts": {
    "serve": "my-command app/",
    "serve:dev": "npm-run-env",
    "serve:prod": "npm-run-env",
    "serve:custom": "npm-run-env"
  }
}
```

The runner will use the script name prefix if no argument is provided.

Default substitution includes:
- `:dev` -> `NODE_ENV=development`
- `:prod` -> `NODE_ENV=production`
- `:local` -> `NODE_ENV=local`
- `:test` -> `NODE_ENV=test`
- `:ci` -> `NODE_ENV=ci`

One can add a custom substitution using an env variable name this way :
- `:<custom_suffix>` will use value from `NPM_RUN_ENV_<custom_suffix_uppercased>_SUBSTITUTION`

And the same way, default substitutions can be changed this way too.

For example :
- `NPM_RUN_ENV_CUSTOM_SUBSTITUTION=custom_env` will yield `:custom` -> `NODE_ENV=custom_env`
- `NPM_RUN_ENV_DEV_SUBSTITUTION=custom_dev` will yield `:dev` -> `NODE_ENV=custom_dev`

### Limitation

The runner expect to be used directly in package.json scripts, it won't work if you do an indirect execution :
```
{
  "scripts": {
    "env": "npm-run-env",
    "serve:dev": "npm run env" // WON'T WORK
  }
}
```
