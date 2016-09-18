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

nobase_include_HEADERS = jvpp/org_openvpp_jvpp_nsh_JVppNshImpl.h

jarfile_jnsh_sfc = jnsh_sfc-$(PACKAGE_VERSION).jar
# fixme update dirs after package in jvpp is changed from org.openvpp.jvpp to io.fd.vpp
java_packagedir = io/fd/nsh_sfc/jvpp
java_gendir = jvpp/src/main/java
resourcesdir = jvpp/src/main/resources
api_file=$(srcdir)/../nsh/nsh.api
jvpp_gen = jvpp_gen.py


lib_LTLIBRARIES = libjvpp_nsh.la
libjvpp_nsh_la_SOURCES = ../vpp-api/nsh.api.h jvpp/jvpp_nsh.c jvpp/org_openvpp_jvpp_nsh_JVppNshImpl.h
libjvpp_nsh_la_LIBADD = -lvlibmemoryclient -lvlibapi -lsvm -lvppinfra \
	              -lpthread -lm -lrt -ljvpp_common
libjvpp_nsh_la_LDFLAGS = -module
libjvpp_nsh_la_CPPFLAGS = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -I../ -I$(srcdir)/../

BUILT_SOURCES = jvpp/org_openvpp_jvpp_nsh_JVppNshImpl.h

jvpp/org_openvpp_jvpp_nsh_JVppNshImpl.h: defs_nsh_sfc_papi.py
	dir=`pwd`;						\
	mkdir -p $(java_gendir)/$(java_packagedir); 		\
	cd $(java_gendir)/$(java_packagedir);			\
	mkdir -p dto future callfacade callback notification test; 	\
	$(jvpp_gen) -i $${dir}/defs_nsh_sfc_papi.py --plugin_name nsh --control_ping_class NshControlPing;		\
	cd -;							\
	mv -f $(java_gendir)/$(java_packagedir)/jvpp_nsh_gen.h jvpp/jvpp_nsh_gen.h;							\
	cp $(srcdir)/pom.xml jvpp/;				\
	cp $(srcdir)/jvpp/test/*.java $(java_gendir)/$(java_packagedir)/test/;				\
	cd jvpp;				\
	mvn $${MAVEN_SETTINGS_OPTIONS} -v;	\
	mvn $${MAVEN_SETTINGS_OPTIONS} clean process-classes;

$(jarfile_jnsh_sfc): libjvpp_nsh.la
	mkdir -p $(resourcesdir);				\
	cp .libs/libjvpp_nsh.so.0.0.0 $(resourcesdir);				\
	cd jvpp;				\
	mvn $${MAVEN_SETTINGS_OPTIONS} -v;	\
	mvn $${MAVEN_SETTINGS_OPTIONS} package;

defs_nsh_sfc_papi.py:
	@echo "  jNsh_sfc API"; \
        vppapigen --input $(api_file) --python defs_nsh_sfc_papi.py;
        
all-local: $(jarfile_jnsh_sfc)
