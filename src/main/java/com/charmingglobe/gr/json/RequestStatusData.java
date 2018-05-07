package com.charmingglobe.gr.json;

import java.util.List;

public class RequestStatusData {

    private String size;
    private List<RequestStatusDataItems> items;

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public void setItems(List<RequestStatusDataItems> items) {
        this.items = items;
    }

    public List<RequestStatusDataItems> getItems() {
        return items;
    }
}
