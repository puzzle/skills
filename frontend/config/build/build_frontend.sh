#!/bin/bash

npm install
bower install

ember build --environment production
