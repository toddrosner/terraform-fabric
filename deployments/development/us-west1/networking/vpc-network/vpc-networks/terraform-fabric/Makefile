.EXPORT_ALL_VARIABLES:

TF_GCS_PATH := $(shell git rev-parse --show-prefix)
TF_BUCKET_REGION := MULTI_REGIONAL
DIR := $(shell pwd)

ifndef TOP_DIR
    TOP_DIR := $(shell git rev-parse --show-toplevel)
endif

.PHONY: all test

include $(TOP_DIR)/lib/_makefile
