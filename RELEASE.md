# Release Notes    {#release_notes}

* @subpage release_notes_1710
* @subpage release_notes_1707
* @subpage release_notes_1704
* @subpage release_notes_1701
* @subpage release_notes_1609

@page release_notes_1710 Release notes for NSH_SFC 17.10

## Features
- Add NSH TTL support

## Issues fixed


@page release_notes_1707 Release notes for NSH_SFC 17.07

## Features
- NSH over Ethernet
  - Add Eth as NSH transport. NSHSFC-31
  - Fix adj lookup failure for NSH over Eth
  - Unit test output:
    https://wiki.fd.io/view/File:NSH_over_Ethernet.png

- iOAM over NSH
  - Changes for supoprting iOAM/ NSH export

## Issues fixed
- Fix gre issue due to gre spit into gre4 and gre6

- NSH-Classifier failed and cause packets dropped. NSHSFC-28

- Fix dual-loop issue of NSH-SNAT. NSHSFC-30


@page release_notes_1704 Release notes for NSH_SFC 17.04

## Features
- NSH MD-Type 2
  - Design document:
    https://wiki.fd.io/view/File:NSH_MD-type_2_support_in_VPP_v2.pptx

- iOAM Trace over NSH
  - Unit test output:
    https://wiki.fd.io/images/3/38/IOAM_Trace_Output.png
  - Thanks Vengada Prasad Govindan for developing this feature.

- NSH-aware SNAT
  - Unit test output:
    https://wiki.fd.io/view/File:NSH_SNAT_Output.png
  - Depends on this patch to be merged to make it work:
    https://gerrit.fd.io/r/#/c/6439/ Fix mac check issue for virtual tunnel interface with no mac address

- Integration Test
  - Thanks Qun Wan and Fangyin Hu for running the integration test of VPP 17.04 and NSH_SFC 17.04-rc2.

- Integration with other LF projects
  - Thanks Yi Yang for integrating NSH-Proxy feature into ODL SFC project.


@page release_notes_1701 Release notes for NSH_SFC 17.01

## Features
- NSH Classifier
  - NSH Classifier enablement:
    https://jira.fd.io/browse/NSHSFC-16
  - Design document:
    https://wiki.fd.io/images/c/c6/NSH-Classifier-Diagram.png
  - Unit test output:
    https://wiki.fd.io/view/File:NSH-Classifier-Output.png

- NSH-Proxy
  - Enable NSH Proxy feature to support integrating NSH-unaware SFs into SFC:
    https://jira.fd.io/browse/NSHSFC-15
  - Unit test output:
    https://wiki.fd.io/images/2/2c/NSH_Proxy_output.png

- Integration Test
  - CSIT team Fangyin Hu tested the integration of VPP 17.01, NSH_SFC 17.01-rc3 and HC 17.01-rc1.
  - Yi Yang tested SFF feature through the integration of ODL SFC, VPP 17.01, NSH_SFC 17.01 and HC 17.01-rc1.

- Performance Test
  - Test output:
    https://wiki.fd.io/view/NSH_SFC/Docs/Performance

@page release_notes_1609 Release notes for NSH_SFC 16.09

## Features
- SFF functionality
  - Initial commit

- Support for VXLAN-GPE and GRE

- Honeycomb integration
  - JVPP addition for automatic JAR generation

- Honeycomb NSH plugin support

- NSH_SFC Packaging


