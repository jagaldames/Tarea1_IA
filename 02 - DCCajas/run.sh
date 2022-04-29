#!/bin/sh
clingo main.lp | python3 process.py > config.js
