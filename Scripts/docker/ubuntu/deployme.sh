#!/bin/bash

# docker login (+ enter username and password)
docker tag pv-v5.6.0-egl kitware/paraviewweb:pv-v5.6.0-egl
docker push kitware/paraviewweb:pv-v5.6.0-egl
