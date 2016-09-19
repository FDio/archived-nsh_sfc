%define _topdir          %(pwd)
%define _builddir        %{_topdir}
%define _version         %(../scripts/version rpm-version)
%define _release         %(../scripts/version rpm-release)

Name: vpp-nsh-plugin
Summary: Vector Packet Processing
License: Apache
Version: %{_version}
Release: %{_release}
Requires: vpp 
%description
This package provides an nsh plugin for vpp

%package devel
Summary: VPP header files, static libraries
Group: Development/Libraries
Requires: vpp-nsh-plugin = %{_version}-%{_release}, vpp-devel 
%description devel
This package contains the headers for C bindings for the vpp-nsh-plugin

%install
#
# vpp-nsh-plugin
#
mkdir -p -m755 %{buildroot}/usr/lib/vpp_plugins
install -m 644 %{_plugin_prefix}/lib/vpp_plugins/nsh_plugin.so %{buildroot}/usr/lib/vpp_plugins/nsh_plugin.so
mkdir -p -m755 %{buildroot}/usr/lib/vpp_api_test_plugins
install -m 644 %{_plugin_prefix}/lib/vpp_api_test_plugins/nsh_test_plugin.so %{buildroot}/usr/lib/vpp_api_test_plugins/nsh_test_plugin.so

# 
# vpp-nsh-plugin-devel
#
mkdir -p -m755 %{buildroot}%{_includedir}/vpp-api/
install -m 644 %{_plugin_prefix}/include/vpp-api/nsh_all_api_h.h %{buildroot}%{_includedir}/vpp-api/nsh_all_api_h.h
install -m 644 %{_plugin_prefix}/include/vpp-api/nsh_msg_enum.h %{buildroot}%{_includedir}/vpp-api/nsh_msg_enum.h
install -m 644 %{_plugin_prefix}/include/vpp-api/nsh.api.h %{buildroot}%{_includedir}/vpp-api/nsh.api.h


%files
%defattr(-,bin,bin)
/usr/lib/vpp_plugins/nsh_plugin.so
/usr/lib/vpp_api_test_plugins/nsh_test_plugin.so

%files devel
%defattr(-,bin,bin)
%{_includedir}/*
