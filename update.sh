#!/bin/bash
date_v=$(date)
git add *
git commit -m "$(date)"
git push
