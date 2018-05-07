package com.charmingglobe.gr.json;

public class QueryRequestStatusInfo {
    private String status;
    private String msg;
    private RequestStatusData data;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public RequestStatusData getData() {
        return data;
    }

    public void setData(RequestStatusData data) {
        this.data = data;
    }
}
