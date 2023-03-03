package com.example.leboncoin;

public class AdModel {
    private String title;
    private String address;
    private int image;
    // Constructor
    public AdModel(String title, String address, int image) {
        this.title = title;
        this.address = address;
        this.image = image;
    }
    public String getTitle() {
        return title;
    }
    public String getAddress() {
        return address;
    }
    public int getID() {
        return image;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public void setImage(int image) {
        this.image = image;
    }


}
