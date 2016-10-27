/*
 * Copyright (c) 2015 Cisco and/or its affiliates.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef included_nsh_h
#define included_nsh_h

#include <vnet/vnet.h>
#include <nsh/nsh_packet.h>
#include <vnet/ip/ip4_packet.h>

typedef struct {

  /** Key for nsh_header_t entry: 24bit NSP 8bit NSI */
  u32 nsp_nsi;

  /** Key for nsh_header_t entry to map to. : 24bit NSP 8bit NSI
   *  This may be ~0 if next action is to decap to NSH next protocol
   *  Note the following heuristic:
   *  if nsp_nsi == mapped_nsp_nsi then use-case is like SFC SFF
   *  if nsp_nsi != mapped_nsp_nsi then use-case is like SFC SF
   *  Note: these are heuristics. Rules about NSI decrement are out of scope
   */
  u32 mapped_nsp_nsi;

  /* NSH Header action: swap, push and pop */
  u32 nsh_action;

  /* vnet intfc sw_if_index */
  u32 sw_if_index;

  u32 next_node;

} nsh_map_t;

typedef struct {
  nsh_map_t map;
  u8 is_add;
} nsh_add_del_map_args_t;

typedef struct {
  u8 is_add;
  nsh_header_t nsh;
} nsh_add_del_entry_args_t;

typedef struct {
  /* API message ID base */
  u16 msg_id_base;

  /* vector of nsh_header entry instances */
  nsh_header_t *nsh_entries;

  /* hash lookup nsh header by key: {u32: nsp_nsi} */
  uword * nsh_entry_by_key;

  /* vector of nsh_mappings */
  nsh_map_t *nsh_mappings;

  /* hash lookup nsh mapping by key: {u32: nsp_nsi} */
  uword * nsh_mapping_by_key;
  uword * nsh_mapping_by_mapped_key; // for use in NSHSFC

  /* convenience */
  vlib_main_t * vlib_main;
  vnet_main_t * vnet_main;
} nsh_main_t;

nsh_main_t nsh_main;

u8 * format_nsh_input_map_trace (u8 * s, va_list * args);
u8 * format_nsh_header_with_length (u8 * s, va_list * args);

/* Helper macros used in nsh.c and nsh_test.c */
#define foreach_copy_nshhdr_field               \
_(ver_o_c)					\
_(length)					\
_(md_type)					\
_(next_protocol)				\
_(nsp_nsi)					\
_(c1)						\
_(c2)						\
_(c3)						\
_(c4)
/* TODO Temp killing tlvs as its causing pain - fix in NSH_SFC */
#define foreach_32bit_field			\
_(nsp_nsi)                                      \
_(c1)                                           \
_(c2)                                           \
_(c3)                                           \
_(c4)

/* Statistics (not really errors) */
#define foreach_nsh_input_error    \
_(MAPPED, "NSH header found and mapped") \
_(NO_MAPPING, "no mapping for nsh key") \
_(NO_ENTRY, "no entry for nsh key") \
_(INVALID_NEXT_PROTOCOL, "invalid next protocol") \

typedef enum {
#define _(sym,str) NSH_INPUT_ERROR_##sym,
    foreach_nsh_input_error
#undef _
  NSH_INPUT_N_ERROR,

} nsh_input_error_t;

#define foreach_nsh_input_next        \
  _(DROP, "error-drop")			\
  _(ENCAP_GRE, "gre-input" )		\
  _(ENCAP_VXLANGPE, "vxlan-gpe-encap" ) \
/* /\* TODO once moved to Project:NSH_SFC *\/ */
  /* _(ENCAP_ETHERNET, "*** TX TO ETHERNET ***")   \ */
/*   _(DECAP_ETHERNET_LOOKUP, "ethernet-input" )	\ */
/*   _(DECAP_IP4_INPUT,  "ip4-input") \ */
/*   _(DECAP_IP6_INPUT,  "ip6-input" ) \  */

typedef enum {
#define _(s,n) NSH_INPUT_NEXT_##s,
  foreach_nsh_input_next
#undef _
  NSH_INPUT_N_NEXT,
} nsh_input_next_t;

typedef enum {
  NSH_ACTION_SWAP,
  NSH_ACTION_PUSH,
  NSH_ACTION_POP
};

#endif /* included_nsh_h */
