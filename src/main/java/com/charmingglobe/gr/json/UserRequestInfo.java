package com.charmingglobe.gr.json;

import java.util.List;

public class UserRequestInfo {
    private String requestID;
    private String RequestName;
    private int priority;
    private String resolution;
    private String sideAngel;
    private String cloudPecent;
    private String geometryRequest;
    private String radiationRequest;
    private String requestType;
    private String imagingGeometry;
    private List <ImagingRequirement> imagingRequirement;
    private String imagingMode;
    private String imagingDuration;
    private String isMultiGrid;
    private String requestStartTime;
    private String requestEndTime;
    private int shootNum;
    private String productDeliveryModel;
    private String productDeliveryTime;
    private String productLevel;
    private String productType;
    private String spectrum;
    private String coverage;

    public List<ImagingRequirement> getImagingRequirement() {
        return imagingRequirement;
    }

    public void setImagingRequirement(List<ImagingRequirement> imagingRequirement) {
        this.imagingRequirement = imagingRequirement;
    }

    public String getSideAngel() {
        return sideAngel;
    }

    public void setSideAngel(String sideAngel) {
        this.sideAngel = sideAngel;
    }

    public String getCloudPecent() {
        return cloudPecent;
    }

    public void setCloudPecent(String cloudPecent) {
        this.cloudPecent = cloudPecent;
    }

    public String getGeometryRequest() {
        return geometryRequest;
    }

    public void setGeometryRequest(String geometryRequest) {
        this.geometryRequest = geometryRequest;
    }

    public String getRadiationRequest() {
        return radiationRequest;
    }

    public void setRadiationRequest(String radiationRequest) {
        this.radiationRequest = radiationRequest;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getImagingGeometry() {
        return imagingGeometry;
    }

    public void setImagingGeometry(String imagingGeometry) {
        this.imagingGeometry = imagingGeometry;
    }

    public String getImagingMode() {
        return imagingMode;
    }

    public void setImagingMode(String imagingMode) {
        this.imagingMode = imagingMode;
    }

    public String getImagingDuration() {
        return imagingDuration;
    }

    public void setImagingDuration(String imagingDuration) {
        this.imagingDuration = imagingDuration;
    }

    public String getIsMultiGrid() {
        return isMultiGrid;
    }

    public void setIsMultiGrid(String isMultiGrid) {
        this.isMultiGrid = isMultiGrid;
    }

    public String getRequestStartTime() {
        return requestStartTime;
    }

    public void setRequestStartTime(String requestStartTime) {
        this.requestStartTime = requestStartTime;
    }

    public String getRequestEndTime() {
        return requestEndTime;
    }

    public void setRequestEndTime(String requestEndTime) {
        this.requestEndTime = requestEndTime;
    }

    public int getShootNum() {
        return shootNum;
    }

    public void setShootNum(int shootNum) {
        this.shootNum = shootNum;
    }

    public String getProductDeliveryModel() {
        return productDeliveryModel;
    }

    public void setProductDeliveryModel(String productDeliveryModel) {
        this.productDeliveryModel = productDeliveryModel;
    }

    public String getProductDeliveryTime() {
        return productDeliveryTime;
    }

    public void setProductDeliveryTime(String productDeliveryTime) {
        this.productDeliveryTime = productDeliveryTime;
    }

    public String getProductLevel() {
        return productLevel;
    }

    public void setProductLevel(String productLevel) {
        this.productLevel = productLevel;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public String getSpectrum() {
        return spectrum;
    }

    public void setSpectrum(String spectrum) {
        this.spectrum = spectrum;
    }

    public String getCoverage() {
        return coverage;
    }

    public void setCoverage(String coverage) {
        this.coverage = coverage;
    }


    public String getRequestID() {
        return requestID;
    }

    public void setRequestID(String requestID) {
        this.requestID = requestID;
    }

    public String getRequestName() {
        return RequestName;
    }

    public void setRequestName(String requestName) {
        RequestName = requestName;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getResolution() {
        return resolution;
    }

    public void setResolution(String resolution) {
        this.resolution = resolution;
    }
}
