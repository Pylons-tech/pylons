# With Docker

This file shows how to use docker, run application on local machine, running tests and generating test reports and running build on local machines.

## Using Docker

1. [Install Docker](https://docs.docker.com/get-docker/) on your machine.
2. Build your container: `docker build -t nextjs-docker .`.
3. Run your container: `docker run --env-file ./env -p 3000:3000 nextjs-docker`.

You can view your images created with `docker images`, and container with `docker ps -a`.

Note: You can change .env values and re-run the conatiner by `docker restart <container-name/container-id>`

## Setting up Enviroment

Following Requirements Sould be Fullfilled before running the application

1. Enviroment variables should be initialized
2. Node must be installed on machine

## Running on Development Server

```bash
npm install
```

```bash
npm run dev
```

## Creating and Running Build on Local Machine

To create build run following command

```bash
npm install
```

```bash
npm run build
```

To run build file run following command

```bash
npm start
```

# Next.js + Jest

This project uses Jest for unit testing

## How to Test

In your terminal, run the following command:

### Running tests

```bash
npm run test
```

### Generating test report

```bash
npm run test-coverage
```
