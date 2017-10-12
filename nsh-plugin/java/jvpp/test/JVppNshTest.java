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

import io.fd.vpp.jvpp.JVpp;
import io.fd.vpp.jvpp.JVppRegistry;
import io.fd.vpp.jvpp.JVppRegistryImpl;
import io.fd.vpp.jvpp.VppCallbackException;
import io.fd.vpp.jvpp.VppJNIConnection;

import io.fd.vpp.jvpp.nsh.dto.*;
import io.fd.vpp.jvpp.nsh.callback.*;
import io.fd.vpp.jvpp.nsh.*;

/**
 * Tests the Nsh Jvpp wrapper (callback API). Run using:
 * 
 * sudo java -cp path/to/jvpp-registry-16.09-SNAPSHOT.jar:path/to/nsh-sfc-16.09-SNAPSHOT.jar io.fd.vpp.jvpp.nsh.test.JVppNshTest
 */
public class JVppNshTest {

    static class TestCallback implements NshAddDelEntryReplyCallback, NshEntryDetailsCallback {

        @Override
        public void onNshAddDelEntryReply(final NshAddDelEntryReply msg) {
            System.out.printf("Received NshAddDelEntryReply: context=%d\n", msg.context);
        }
        @Override
        public void onNshEntryDetails(final NshEntryDetails msg)  {
            System.out.printf("Received NshEntryDetails: context=%d, nspNsi=%d, mdType=%d, verOC=%d, length=%d, nextProtocol=%d\n",
            		msg.context, msg.nspNsi, msg.mdType, msg.verOC, msg.length, msg.nextProtocol);
        }

        @Override
        public void onError(VppCallbackException ex) {
            System.out.printf("Received onError exception: call=%s, context=%d, retval=%d\n", ex.getMethodName(), ex.getCtxId(), ex.getErrorCode());
        }
    }

    public static void main(String[] args) throws Exception {
    	testJVppNsh();
    }

    private static void testJVppNsh() throws Exception {    	
        System.out.println("Testing Java callback API with JVppRegistry");
        JVppRegistry registry = new JVppRegistryImpl("NshTest");
        JVpp jvpp = new JVppNshImpl();
        
        registry.register(jvpp, new TestCallback());

        System.out.println("Sending NshAddDelEntryReply request...");
        final NshAddDelEntry request = new NshAddDelEntry();
        
        request.isAdd = 1;
        int nsp = 1;
    	int nsi = 2;
    	request.nspNsi = (nsp<<8) | nsi;
    	request.mdType = 1;
    	request.verOC = 0;
    	request.length = 6;
    	request.nextProtocol = 1;
        
        int result = jvpp.send(request);
        System.out.printf("NshAddDelEntryReply send result = %d\n", result);

        Thread.sleep(2000);
        

        System.out.println("Sending NshEntryDump request...");
        result = jvpp.send(new NshEntryDump());
        System.out.printf("NshEntryDump send result = %d\n", result);
        

        Thread.sleep(2000);

        System.out.println("Disconnecting...");
        registry.close();
        Thread.sleep(1000);
    }
}
