package com.vo;

public class Message {
    private String message;
    private String instance;

    public Message() {
    }

    public Message(String message, String instance) {
        this.message = message;
        this.instance = instance;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getInstance() {
        return instance;
    }

    public void setInstance(String instance) {
        this.instance = instance;
    }
}
