package com.example;

import com.vo.Message;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.io.File;
import java.io.InputStream;

/**
 * Root resource (exposed at "myresource" path)
 */
@Path("docs")
public class MyResource {

    public MyResource() {
        System.out.println("Loaded My Resource");
    }

    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getIt() {
        return "Got it! " + System.getenv("INSTANCE");
    }

    @POST
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces(MediaType.APPLICATION_JSON)
    public Message uploadFile(
        @FormDataParam("file") InputStream file,
        @FormDataParam("file") FormDataContentDisposition fileDisposition) throws InterruptedException {
        Thread.sleep(1_000);
        return new Message(fileDisposition.getFileName(), System.getenv("INSTANCE"));
    }
}
