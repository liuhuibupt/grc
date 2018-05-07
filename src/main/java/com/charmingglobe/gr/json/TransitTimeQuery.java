package com.charmingglobe.gr.json;

public class TransitTimeQuery {



        private String requestName;
        private String longitude;
        private String latitude;
        private String satelliteId;
        private String startTime;
        private String endTime;
        public void setRequestName(String requestName) {
            this.requestName = requestName;
        }
        public String getRequestName() {
            return requestName;
        }

        public void setLongitude(String longitude) {
            this.longitude = longitude;
        }
        public String getLongitude() {
            return longitude;
        }

        public void setLatitude(String latitude) {
            this.latitude = latitude;
        }
        public String getLatitude() {
            return latitude;
        }

        public void setSatelliteId(String satelliteId) {
            this.satelliteId = satelliteId;
        }
        public String getSatelliteId() {
            return satelliteId;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }
        public String getStartTime() {
            return startTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }
        public String getEndTime() {
            return endTime;
        }


}
