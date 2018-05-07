package com.charmingglobe.gr.json;

public class ImagingRequirement {
    private String satelliteID;
    private String imagingID;
    private String startTime;
    private String endTime;
    private int times;
    public String getSatelliteID() {
        return satelliteID;
    }

    public void setSatelliteID(String satelliteID) {
        this.satelliteID = satelliteID;
    }

    public String getImagingID() {
        return imagingID;
    }

    public void setImagingID(String imagingID) {
        this.imagingID = imagingID;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public int getTimes() {
        return times;
    }

    public void setTimes(int times) {
        this.times = times;
    }


}


