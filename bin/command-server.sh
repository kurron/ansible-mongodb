#!/bin/bash

ansible testserver --module-name command --args $1
