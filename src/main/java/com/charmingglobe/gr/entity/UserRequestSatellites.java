package com.charmingglobe.gr.entity;

import com.charmingglobe.gr.hibernate.JSONBUserType;
import com.vividsolutions.jts.geom.Geometry;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import javax.persistence.*;
import java.util.Date;
import java.util.Map;

/**
 * Created by Liuhui on 2018/3/17.
 */
@Entity
@Table(name = "grc_user_request_satellites")
@TypeDef(name = "jsonb", typeClass = JSONBUserType.class)
public class UserRequestSatellites {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    private int id;

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "request_num")
    private UserRequest userRequest;

    @Column(name = "request_satellites")
    private String requestSatellites;

    @Column(name = "imaging_id")
    private String imagingId;

    @Column(name = "return_imaging_status")
    private String returnImagingStatus;

    @Column(name = "imaging_mode")
    private String imagingMode;

    @Column(name = "imaging_duration")
    private String imagingDuration;

    @Column(name = "is_multi_grid")
    private boolean isMultiGrid;

    @Column(name = "request_start")
    private Date requestStart;

    @Column(name = "request_end")
    private Date requestEnd;

    @Column(name = "shoot_num")
    private int shootNum;

    @Column(name = "product_delivery_model")
    private String productDeliveryModel;

    @Column(name = "product_delivery_url")
    private String productDeliveryURL;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReturnImagingStatus() {
        return returnImagingStatus;
    }

    public void setReturnImagingStatus(String returnImagingStatus) {
        this.returnImagingStatus = returnImagingStatus;
    }

    public UserRequest getUserRequest() {
        return userRequest;
    }

    public void setUserRequest(UserRequest userRequest) {
        this.userRequest = userRequest;
    }

    public String getRequestSatellites() {
        return requestSatellites;
    }

    public String getImagingId() {
        return imagingId;
    }

    public void setImagingId(String imagingId) {
        this.imagingId = imagingId;
    }

    public void setRequestSatellites(String requestSatellites) {
        this.requestSatellites = requestSatellites;
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

    public boolean isMultiGrid() {
        return isMultiGrid;
    }

    public void setMultiGrid(boolean multiGrid) {
        isMultiGrid = multiGrid;
    }

    public Date getRequestStart() {
        return requestStart;
    }

    public void setRequestStart(Date requestStart) {
        this.requestStart = requestStart;
    }

    public Date getRequestEnd() {
        return requestEnd;
    }

    public void setRequestEnd(Date requestEnd) {
        this.requestEnd = requestEnd;
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

    public String getProductDeliveryURL() {
        return productDeliveryURL;
    }

    public void setProductDeliveryURL(String productDeliveryURL) {
        this.productDeliveryURL = productDeliveryURL;
    }
}




