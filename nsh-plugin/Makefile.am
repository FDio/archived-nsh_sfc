
# Copyright (c) <current-year> <your-organization>
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

AUTOMAKE_OPTIONS = foreign subdir-objects

AM_CFLAGS = -Wall -I@TOOLKIT_INCLUDE@

lib_LTLIBRARIES = nsh_plugin.la nsh_test_plugin.la
nsh_plugin_la_SOURCES = nsh/nsh.c  \
	nsh/nsh_plugin.api.h 
nsh_plugin_la_LDFLAGS = -module

BUILT_SOURCES = nsh/nsh.api.h

SUFFIXES = .api.h .api

%.api.h: %.api
	mkdir -p `dirname $@` ; \
	$(CC) $(CPPFLAGS) -E -P -C -x c $^ \
	| vppapigen --input - --output $@ --show-name $@

nobase_include_HEADERS =			\
  nsh/nsh_all_api_h.h			\
  nsh/nsh_msg_enum.h			\
  nsh/nsh.api.h

nsh_test_plugin_la_SOURCES = \
  nsh/nsh_test.c nsh/nsh_plugin.api.h
nsh_test_plugin_la_LDFLAGS = -module

install-data-hook:
	mkdir $(prefix)/lib/vpp_plugins || true
	mkdir $(prefix)/lib/vpp_api_test_plugins || true
	cp $(prefix)/lib/nsh_plugin.so.*.*.* $(prefix)/lib/vpp_plugins
	cp $(prefix)/lib/nsh_test_plugin.so.*.*.* \
		$(prefix)/lib/vpp_api_test_plugins
	rm -f $(prefix)/lib/nsh_plugin.*
	rm -f $(prefix)/lib/nsh_test_plugin.*

