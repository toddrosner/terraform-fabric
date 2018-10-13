default:
	@echo $(PWD)
	@echo $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
	@echo $(sort $(dir $(PWD)))

LIB_DIR := ../../../../../lib

LOOKUP := $(LIB_DIR)/account_lookup.go

.PHONY: test

test:
	go run $(LOOKUP)


.PHONY: all

include $(TOPDIR)/terraform/_makefile
