# Copyright (c) 2016 Cisco and/or its affiliates.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

WS_ROOT=$(CURDIR)
BR=$(WS_ROOT)/build-root

#
# OS Detection
#
OS_ID        = $(shell grep '^ID=' /etc/os-release | cut -f2- -d= | sed -e 's/\"//g')
OS_VERSION_ID= $(shell grep '^VERSION_ID=' /etc/os-release | cut -f2- -d= | sed -e 's/\"//g')

help:
	@echo "Make Targets:"
	@echo " doxygen             - (re)generate documentation"
	@echo " bootstrap-doxygen   - setup Doxygen dependencies"
	@echo " wipe-doxygen        - wipe all generated documentation"
	@echo ""



#
# Build the documentation
#

# Doxygen configuration and our utility scripts
export DOXY_DIR ?= $(WS_ROOT)/doxygen

define make-doxy
	@OS_ID="$(OS_ID)" WS_ROOT="$(WS_ROOT)" BR="$(BR)" make -C $(DOXY_DIR) $@
endef

.PHONY: bootstrap-doxygen doxygen wipe-doxygen

bootstrap-doxygen:
	$(call make-doxy)

doxygen:
	$(call make-doxy)

wipe-doxygen:
	$(call make-doxy)

