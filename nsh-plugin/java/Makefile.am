# Copyright (c) 2015 Cisco and/or its affiliates.
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
ACLOCAL_AMFLAGS = -I m4
AM_CFLAGS = -Wall 


noinst_PROGRAMS =
BUILT_SOURCES =
bin_PROGRAMS =
CLEANFILES =

nobase_include_HEADERS = jvpp/io_fd_vpp_jvpp_nsh_JVppNshImpl.h

jarfile_jnsh_sfc = jnsh_sfc-$(PACKAGE_VERSION).jar
java_packagedir = io/fd/vpp/jvpp/nsh
java_gendir = jvpp/src/main/java
resourcesdir = jvpp/src/main/resources
api_file=$(srcdir)/../nsh/nsh.api
jvpp_gen = jvpp_gen.py


lib_LTLIBRARIES = libjvpp_nsh.la

libjvpp_nsh_la_SOURCES = $(srcdir)/../java/nsh.api.h jvpp/jvpp_nsh.c jvpp/io_fd_vpp_jvpp_nsh_JVppNshImpl.h

libjvpp_nsh_la_LIBADD = -lvlibmemoryclient -lsvm -lvppinfra \
	              -lpthread -lm -lrt -ljvpp_common
libjvpp_nsh_la_LDFLAGS = -module
libjvpp_nsh_la_CPPFLAGS = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -I../ -I$(srcdir)/../

BUILT_SOURCES = jvpp/io_fd_vpp_jvpp_nsh_JVppNshImpl.h

jvpp/io_fd_vpp_jvpp_nsh_JVppNshImpl.h: nsh.api.json
	$(jvpp_gen) -i nsh.api.json --plugin_name nsh --root_dir $(java_gendir)/$(java_packagedir)  > /dev/null;  \
	mv -f $(java_gendir)/$(java_packagedir)/target/io/fd/vpp/jvpp/nsh/* $(java_gendir)/$(java_packagedir)/;  \
	mv -f $(java_gendir)/$(java_packagedir)/jvpp_nsh_gen.h jvpp/jvpp_nsh_gen.h;							\
	cp $(srcdir)/pom.xml jvpp/;				\
	mkdir -p $(java_gendir)/$(java_packagedir)/test;
	cp $(srcdir)/jvpp/test/*.java $(java_gendir)/$(java_packagedir)/test/;				\
	cd jvpp;				\
	mvn $${MAVEN_SETTINGS_OPTIONS} -v;	\
	mvn $${MAVEN_SETTINGS_OPTIONS} clean process-classes;

$(jarfile_jnsh_sfc): libjvpp_nsh.la
	mkdir -p $(resourcesdir);				\
	cp .libs/libjvpp_nsh.so $(resourcesdir)/libjvpp_nsh.so;	\
	cd jvpp;				\
	mvn $${MAVEN_SETTINGS_OPTIONS} -v;	\
	mvn $${MAVEN_SETTINGS_OPTIONS} package;

nsh.api.json: $(api_file)
	@echo "  jNsh_sfc API"; \
	$(CC) $(CPPFLAGS) -E -P -C -x c $^ \
	| vppapigen --input $^ JSON --output $@

all-local: $(jarfile_jnsh_sfc)
