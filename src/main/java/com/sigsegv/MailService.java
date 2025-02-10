package com.sigsegv;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.json.JSONObject;

public class MailService {
    static String topic = "mail";
    static String validateTopic = "validate";
    static String parseUrl1 = "http://192.168.1.29:11434/api/generate";
    static String parseUrl2 = "http://192.168.1.136/api/generate";
    static String prompt1;
    static String prompt2;

    private static KafkaConsumer<String, String> consumer;
    public static void main(String[] args) {

        try (BufferedReader br = new BufferedReader(new FileReader("finalprompt.txt"))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            prompt1 = sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "mailServiceGroup");
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
        consumer.subscribe(Collections.singletonList(topic));

        Properties producerProps = new Properties();
        producerProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        producerProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        producerProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        KafkaProducer<String, String> producer = new KafkaProducer<>(producerProps);

        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
            for (ConsumerRecord<String, String> record : records) {
                String message = record.value();
                String promptMessage = generatePrompt(prompt1, message);
                String finalResponse = sendPostRequest(parseUrl1, promptMessage);
                producer.send(new ProducerRecord<>(validateTopic, finalResponse));
            }
        }
    }

    private static String generatePrompt(String prompt, String message) {
        return prompt + message;
    }

    private static String sendPostRequest(String parseUrl, String prompt) {
        StringBuilder concatenatedResponse = new StringBuilder();
        StringBuilder patternMatchResponse = new StringBuilder();
        try {
            URL url = new URL(parseUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setDoOutput(true);

            JSONObject jsonInput = new JSONObject();
            jsonInput.put("model", "mistral");
            jsonInput.put("prompt", prompt);

            String jsonInputString = jsonInput.toString();
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();

            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {

                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    JSONObject jsonResponse = new JSONObject(responseLine.trim());
                    String response = jsonResponse.getString("response");
                    concatenatedResponse.append(response);
                }

                patternMatchResponse =  patternMatch(concatenatedResponse.toString());

                System.out.println("Final Response: " + concatenatedResponse.toString());

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patternMatchResponse.toString();
    }

    private static StringBuilder patternMatch(String input){
     
        StringBuilder completelyFinalResponse = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader("patternMatchPrompt.txt"))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            prompt2 = sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        // Rework on this loop
        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
            for (ConsumerRecord<String, String> record : records) {
                String promptMessage = generatePrompt(prompt2, input);
                completelyFinalResponse.append(sendPostRequest(parseUrl2, promptMessage)).append("\n");
            }
            
            return completelyFinalResponse;
        }
    }
}
