package com.charmingglobe.gr.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService(targetNamespace = "http://webservice.gr.charmingglobe.com/")
public interface ImagingRequestWebService {

    @WebMethod
    String submitUserRequirement(String json);

    @WebMethod
    String getImagingRequirementList(String requestId);

    @WebMethod
    String getImagingRequirement(String imagingId);
}
