#!/bin/bash

# This script create a folder with subfolders with a DIR structure according to the paper:
# A Quick Guide to Organizing Computational Biology Projects. Noble 2009.

# Get parameters
PROJECT_NAME=$1
ROUTE=$2

# Create DIRs
mkdir ${ROUTE}/${PROJECT_NAME}
mkdir ${ROUTE}/${PROJECT_NAME}/doc
mkdir ${ROUTE}/${PROJECT_NAME}/data
mkdir ${ROUTE}/${PROJECT_NAME}/src
mkdir ${ROUTE}/${PROJECT_NAME}/bin
mkdir ${ROUTE}/${PROJECT_NAME}/results
