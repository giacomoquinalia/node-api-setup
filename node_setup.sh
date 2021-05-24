#!/bin/bash


if [ "x$1" = "x" ]; then
    echo "Criando estrutura em $(pwd)"
else
    echo "Criando estrutura em $(pwd)/$1"
    mkdir -p "$1" && cd "$1"
fi

git init
npm init -y
npm i express cors axios dotenv

mkdir docs src \
src/controllers \
src/database \
src/middlewares \
src/models \
src/services \
src/utils

touch \
src/routes.js \
src/database/config.js \
src/services/api.js \
.dockerignore \
docker-compose.yml

echo "SERVER_PORT=3333" > .env
echo "FROM node:alpine" > Dockerfile

# Gitignore
cat << EOF > .gitignore
node_modules
.env
EOF

# API base URL
cat << EOF > src/services/api.js
const axios = require('axios')
require('dotenv').config()

const api = axios.create({
  baseURL: process.env.API_URL
})

module.exports = api
EOF

# Configuring web server file 
cat << EOF > src/server.js
const express = require('express')
const cors = require('cors')
const routes = require('./routes')
const app = express()
require('dotenv').config


// middlewares
app.use(cors)
app.use(express.json())
app.use(routes)


const port = process.env.SERVER_PORT
app.listen(port, () => {
  console.log(\`CORS-enabled web server listening on port \${port}\`)
})
EOF
