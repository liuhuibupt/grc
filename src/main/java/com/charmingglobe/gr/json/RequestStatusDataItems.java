package com.charmingglobe.gr.json;

public class RequestStatusDataItems {
    private  String status;
    private  String stationId;
    private  String imagingId;
    private String startTime;
    private String endTime;

    public String getImagingId() {
        return imagingId;
    }

    public void setImagingId(String imagingId) {
        this.imagingId = imagingId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStationId() {
        return stationId;
    }

    public void setStationId(String stationId) {
        this.stationId = stationId;
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
}
