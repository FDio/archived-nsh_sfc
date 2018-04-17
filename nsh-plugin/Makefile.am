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
SUBDIRS=java
AM_CFLAGS = -Wall -Werror -I@TOOLKIT_INCLUDE@

nsh_plugin_la_CPPFLAGS = -DDEBUG -g
nsh_test_plugin_la_CPPFLAGS = -DDEBUG -g

CPPFLAGS += -DDEBUG -g

lib_LTLIBRARIES = nsh_plugin.la nsh_test_plugin.la
nsh_plugin_la_SOURCES = nsh/nsh.c  \
	nsh/nsh_pop.c \
	nsh/nsh_output.c \
	vpp-api/nsh.api.h \
	nsh-md2-ioam/nsh_md2_ioam.c \
	nsh-md2-ioam/nsh_md2_ioam_trace.c \
	nsh-md2-ioam/md2_ioam_transit.c \
	nsh-md2-ioam/nsh_md2_ioam_api.c \
	nsh-md2-ioam/export-nsh-md2-ioam/nsh_md2_ioam_export.c \
	nsh-md2-ioam/export-nsh-md2-ioam/nsh_md2_ioam_export_thread.c \
	nsh-md2-ioam/export-nsh-md2-ioam/nsh_md2_ioam_node.c

nsh_plugin_la_LDFLAGS = -module

BUILT_SOURCES = vpp-api/nsh.api.h

SUFFIXES = .api.h .api

vpp-api/%.api.h: nsh/%.api
	mkdir -p `dirname $@` ; \
	$(CC) $(CPPFLAGS) -E -P -C -x c $^ \
	| vppapigen --includedir $(top_srcdir) --input $< --output $@

nobase_include_HEADERS =			\
  vpp-api/nsh_all_api_h.h			\
  vpp-api/nsh_msg_enum.h			\
  vpp-api/nsh.api.h

nsh_test_plugin_la_SOURCES = \
  nsh/nsh_test.c vpp-api/nsh.api.h
nsh_test_plugin_la_LDFLAGS = -module

install-data-hook:
	mkdir $(prefix)/lib/vpp_plugins || true
	mkdir $(prefix)/lib/vpp_api_test_plugins || true
	cp $(prefix)/lib/nsh_plugin.so.*.*.* $(prefix)/lib/vpp_plugins/nsh_plugin.so
	cp $(prefix)/lib/nsh_test_plugin.so.*.*.* \
		$(prefix)/lib/vpp_api_test_plugins/nsh_test_plugin.so
	rm -f $(prefix)/lib/nsh_plugin.*
	rm -f $(prefix)/lib/nsh_test_plugin.*

pkg-rpm: all install
	cd $(srcdir)/packaging/rpm; \
	rpmbuild -bb --define "_topdir $$PWD" \
		--define "_plugin_prefix ${prefix}" vpp-nsh-plugin.spec

pkg-deb: all install
	DOTPREFIX=$$(readlink -f ${srcdir}/packaging/deb/debian); \
	echo DOTPREFIX $${DOTPREFIX}; \
	DOTPREFIX=$$(echo $${DOTPREFIX}| sed 's;[^\/]*;..;g'); \
	echo DOTPREFIX $${DOTPREFIX}; \
	echo ../../$${DOTPREFIX}/$(prefix)/lib/vpp_plugins/nsh_plugin.so /usr/lib/vpp_plugins > $(srcdir)/packaging/deb/debian/vpp-nsh-plugin.install; \
	echo ../../$${DOTPREFIX}/$(prefix)/lib/vpp_api_test_plugins/nsh_test_plugin.so /usr/lib/vpp_api_test_plugins >> $(srcdir)/packaging/deb/debian/vpp-nsh-plugin.install; \
	echo ../../$${DOTPREFIX}/$(prefix)/include/vpp-api/nsh_all_api_h.h /usr/include/vpp-api > $(srcdir)/packaging/deb/debian/vpp-nsh-plugin-dev.install; \
	echo ../../$${DOTPREFIX}/$(prefix)/include/vpp-api/nsh_msg_enum.h /usr/include/vpp-api >> $(srcdir)/packaging/deb/debian/vpp-ns\
h-plugin-dev.install; \
	echo ../../$${DOTPREFIX}/$(prefix)/include/vpp-api/nsh.api.h /usr/include/vpp-api >> $(srcdir)/packaging/deb/debian/vpp-nsh-plugin-dev.install
	$(srcdir)/packaging/scripts/generate-deb-changelog; 				\
	(								\
	cd $(srcdir)/packaging/deb &&							\
	dpkg-buildpackage -us -uc -b					\
	)

