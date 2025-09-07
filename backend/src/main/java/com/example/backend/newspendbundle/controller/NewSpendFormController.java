package com.example.backend.common;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class NewSpendFormController {
    @GetMapping("/api/new-spend/submit-form")
    public Map<String, String> submitForm() {

        return Map.of("status", "ok");
    }
}
