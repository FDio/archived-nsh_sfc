/*
 * Copyright (c) 2016 Cisco and/or its affiliates.
 *
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

package io.fd.vpp.jvpp.nsh.test;

import java.util.concurrent.Future;
import java.util.Objects;

import io.fd.vpp.jvpp.JVpp;
import io.fd.vpp.jvpp.JVppRegistry;
import io.fd.vpp.jvpp.JVppRegistryImpl;
import io.fd.vpp.jvpp.VppCallbackException;
import io.fd.vpp.jvpp.VppJNIConnection;

import io.fd.vpp.jvpp.nsh.dto.*;
import io.fd.vpp.jvpp.nsh.callback.*;
import io.fd.vpp.jvpp.nsh.*;
import io.fd.vpp.jvpp.nsh.future.FutureJVppNshFacade;

/**
 * Tests the Nsh Jvpp wrapper (future API). Run using:
 * 
 * sudo java -cp path/to/jvpp-registry-16.09-SNAPSHOT.jar:path/to/nsh-sfc-16.09-SNAPSHOT.jar io.fd.vpp.jvpp.nsh.test.NshFutureApiTest
 */
public class NshFutureApiTest {

    public static void main(String[] args) throws Exception {
    	testFutureApi();
    }

    private static void testFutureApi() throws Exception {    	
        System.out.println("Testing Java future API for NSH plugin");
        JVppRegistry registry = new JVppRegistryImpl("NshFutureApiTest");
        JVpp jvpp = new JVppNshImpl();
        FutureJVppNshFacade jvppFacade = new FutureJVppNshFacade(registry, jvpp);

        
        testNshAddDelEntry(jvppFacade);
        testNshEntryDump(jvppFacade);

        System.out.println("Disconnecting...");
        registry.close();
        Thread.sleep(1000);
    }
    
    private static void testNshAddDelEntry(final FutureJVppNshFacade jvppFacade) throws Exception {
    	System.out.println("Sending NshAddDelEntry request...");
        final NshAddDelEntry request = new NshAddDelEntry();
        
        request.isAdd = 1;
        int nsp = 1;
    	int nsi = 2;
    	request.nspNsi = (nsp<<8) | nsi;
    	request.mdType = 1;
    	request.verOC = 0;
    	request.length = 6;
    	request.nextProtocol = 1;
        
    	final Future<NshAddDelEntryReply> replyFuture = jvppFacade.nshAddDelEntry(request).toCompletableFuture();
        final NshAddDelEntryReply reply = replyFuture.get();
        
        System.out.printf("Received NshAddDelEntryReply: context=%d\n", reply.context);
    }
    
    private static void testNshEntryDump(final FutureJVppNshFacade jvppFacade) throws Exception {
        System.out.println("Sending NshEntryDump request...");
    	final Future<NshEntryDetailsReplyDump> replyFuture = jvppFacade.nshEntryDump(new NshEntryDump()).toCompletableFuture();
        final NshEntryDetailsReplyDump reply = replyFuture.get();
        for (NshEntryDetails details : reply.nshEntryDetails) {
            Objects.requireNonNull(details, "reply.nshEntryDetails contains null element!");
        	System.out.printf("Received NshEntryDetails: context=%d, nspNsi=%d, mdType=%d, verOC=%d, length=%d, nextProtocol=%d\n",
        	    details.context, details.nspNsi, details.mdType, details.verOC, details.length, details.nextProtocol);
        }
    }
    
}
