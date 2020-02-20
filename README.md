# Server-apps

This repository contains all our scripts and configuration files necessary for custom deployment on our METANET server.

### Deployment

The server-apps repo is currently located on the server under the user `swo` in the folder `apps`. This repo needs to be pulled manually in case of changes. There is no CI/CD yet. This repo provides various hooks which get called when one might push a repo onto the server. See `git` folder under the user `swo`. To trigger a deploy without semaphore, use the following steps in case of dev/develop:

```
ssh-copy-id swo@stiftungswo.ch
git remote add metanet swo@stiftungswo.ch:~/git/better-dime/develop.git
git push -f metanet-develop dev:master
# => build starts...
```
 
### Current sites

- iZivi
- Dime
- LimeSurvey
- NextCloud
- Traefik monitor

## Structure

| Directory | Meaning |
| --------- | ------- |
| `sites/[project]/[environment]` | Contains all deployment and running configuration for each project and each environment.  |
| `dsl/` | Code required to support custom DSL  |
| `hooks/` | Git hooks inserted into each project to connect to custom deployment code |
| `traefik/` | Configuration files required to have reverse proxy working |

## Workflow

The CD pushes to the corresponding git repo on the server. The repo has linked the pre-receive hook with the hook stored in this repo. The hook then infers the project and environment depending on the repo to which was pushed to and then calls the `deploy` and `run` rake task. 

## Rake tasks

### Auto-generated Tasks

#### Deploy Task
When there is a Deployfile in the project-environment folder, there is a rake project:environment:deploy task to execute that Deployfile.

**This Task should only be run by the pre-receive hook** 

#### Run Task
When there is a Runfile in the project-environment folder, there is a rake project:environment:run task to execute that Runfile

#### Stop Task
When there is a Stopfile in the project-environment folder, there is a rake project:environment:stop task to execute that Stopfile

#### Restart Task
When there is a Runfile and Stopfile in the project-environment folder, there is a rake project:environment:restart task to execute that Stopfile and then that Runfile


## DSL

#### Docker commands

##### `build_swo_image`

Builds an image with SWO naming convention.

_Usage:_

```ruby
build_swo_image(
  docker_name_supplement: 'name supplement e.g. frontend', # Optional
  ...[additional build arguments]
)
```

Produces an image built from the current `prod.Dockerfile` inferred from current working directory.

Naming will be `swo/[project name]_[supplement]:[environment]`. Environment tags are used to support caching across multiple project instances (only if they differ marginally from each other).

<br>

##### `swo_container_name`

Returns a container name using SWO naming convention based on the project name and environment.

_Usage:_

```ruby
swo_container_name(
  'supplement e.g. frontend' # Optional
)
```

Returns a string following the format `[project_name]_[environment]_[supplement]`, e.g. `better_dime_develop_frontend`

<br>

##### `swo_image_name`

Returns an image name using SWO naming convention based on the project name and environment.

_Usage:_

```ruby
swo_image_name(
  'supplement e.g. frontend' # Optional
)
```

Returns a string following the format `swo/[project_name]_[supplement]:[environment]`, e.g. `swo/better_dime_frontend:develop`

<br>

##### `start_swo_docker_image`

Stops the running container using the same image and starts a new instance.

_Usage:_

```ruby
start_swo_docker_image(
  docker_name_supplement: 'supplement e.g. frontend', # Optional
  ...[additional run flags]
)
```

<br>

##### `migrate_swo_rails_db`

Migrates a Rails database

_Usage:_

```ruby
migrate_swo_rails_db(
  'naming supplement of the rails container e.g. api' # Optional
)
```

<br>

##### `migrate_swo_laravel_db`

Migrates a Laravel database

_Usage:_

```ruby
migrate_swo_laravel_db(
  'naming supplement of the rails container e.g. api' # Optional
)
```

<br>

#### Env file handling

##### `load_environment_file`

Loads the specified environment file into `ENV`.

_Usage:_

```ruby
load_environment_file(
  '.env file path' # Optional
)
```

If path is `nil` a `.env` file will be searched in the current working directory.

<br>

##### `default_env_file`

Returns the path of the default `.env` file, which basically is `$(pwd)/.env`

_Usage:_

```ruby
default_env_file()
```

<br>

### Pre-Receive Hook

#### Rake tasks

##### `execute_rake_command`

Runs a given rake task
