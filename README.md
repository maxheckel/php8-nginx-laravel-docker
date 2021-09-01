# PHP 8 Dockerfile Setup for Laravel 
This is intended to be a package to allow you to copy its contents into a folder in your project `{project_folder}/.docker` 
Then build and tag it to create an all in one containerized php application.

It is built specifically for laravel `^8.40` but could be tweaked to be used for other frameworks or
versions of laravel.


## How to use it
* Create a new folder `/path/to/your/project/.docker`.  For laravel apps you should create the `.docker` folder at the same level as the `app` folder
* Copy the contents of this entire repo (minus the readme.md) to the newly created `.docker` folder.
* Run your build commands with the `-f` flag pointing at the `Dockerfile` in the `.docker` folder. i.e. `docker build -t myname/myproject:v0.0.1 -f ./.docker/Dockerfile .`


### Note on M1 Machines and ECS
If you're using ECS then you might need to build it using the new `buildx` command. Run something like this
`docker buildx build --platform=linux/amd64 -t myname/myproject:v0.0.2 -f .docker/Dockerfile .`

