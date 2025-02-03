package com.deloitteHackathon.testEmail.service;

public interface EmailSenderService {
    void sendEmail(String to, String subject, String message);
}
